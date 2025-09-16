// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ComplaintViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // String presignedURl =
  //     'https://s3.ap-south-1.amazonaws.com/ngbucket24/path/to/file.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA37AU3X2R3LLZUK76%2F20250915%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20250915T141612Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=0c404571f7f118042e0b65058ae385e278137cb290baf61e48bca21c0fae472a';

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _complaints = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get complaints => _complaints;
  String awsAccessKey = 'AKIA37AU3X2R4WOVDZ4U';
  String awsSecretKey = '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';
  String region = 'ap-south-1';
  String bucketName = 'ngbucket24';

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  String _generateComplaintId() {
    return const Uuid().v4();
  }

  String _generateIssueId() {
    return const Uuid().v6();
  }

  // Your upload function with minor improvements
  Future<String?> _uploadFileToS3(File file, String presignedUrl) async {
    try {
      print('Starting upload to S3: $presignedUrl');
      final bytes = await file.readAsBytes();
      print('File read successfully, size: ${bytes.length} bytes');

      final response = await http.put(
        Uri.parse(presignedUrl),
        body: bytes,
        headers: {'Content-Type': 'application/octet-stream'},
      );

      print('HTTP response received, status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('S3 upload successful');
        // Accessible URL is presigned URL without query params
        final fileUrl = presignedUrl.split('?').first;
        print('File accessible at: $fileUrl');
        return fileUrl;
      } else {
        print('S3 upload failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e, stacktrace) {
      print('S3 upload exception: $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
  }

  // Generate a presigned URL for S3 upload with correct signature calculation
  Future<String> _generatePresignedUrl(String fileName) async {
    final now = DateTime.now().toUtc();
    final amzDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}Z';
    final dateStamp = amzDate.substring(0, 8);

    // Credential scope
    final credentialScope = '$dateStamp/$region/s3/aws4_request';

    // Generate the signature
    const algorithm = 'AWS4-HMAC-SHA256';
    const expiration = 3600; // URL expires in 1 hour

    // Create the canonical request
    final canonicalUri = '/$fileName';
    final canonicalQueryString =
        'X-Amz-Algorithm=AWS4-HMAC-SHA256'
        '&X-Amz-Credential=${Uri.encodeComponent('$awsAccessKey/$credentialScope')}'
        '&X-Amz-Date=$amzDate'
        '&X-Amz-Expires=$expiration'
        '&X-Amz-SignedHeaders=host';

    final canonicalHeaders = 'host:${bucketName}.s3.$region.amazonaws.com\n';
    const signedHeaders = 'host';
    const payloadHash = 'UNSIGNED-PAYLOAD';

    final canonicalRequest =
        'PUT\n$canonicalUri\n$canonicalQueryString\n$canonicalHeaders\n$signedHeaders\n$payloadHash';
    print('Canonical Request: $canonicalRequest');

    // Create string to sign
    final stringToSign =
        '$algorithm\n$amzDate\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest))}';
    print('String to Sign: $stringToSign');

    // Calculate the signature
    final signingKey = _getSignatureKey(awsSecretKey, dateStamp, region, 's3');
    final signature = Hmac(
      sha256,
      signingKey,
    ).convert(utf8.encode(stringToSign)).toString();
    print('Calculated Signature: $signature');

    // Construct the presigned URL
    final presignedUrl =
        'https://$bucketName.s3.$region.amazonaws.com$canonicalUri?$canonicalQueryString&X-Amz-Signature=$signature';

    return presignedUrl;
  }

  // Helper function to generate the signing key
  List<int> _getSignatureKey(
    String key,
    String dateStamp,
    String regionName,
    String serviceName,
  ) {
    final kSecret = utf8.encode('AWS4$key');
    final kDate = Hmac(sha256, kSecret).convert(utf8.encode(dateStamp)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(regionName)).bytes;
    final kService = Hmac(
      sha256,
      kRegion,
    ).convert(utf8.encode(serviceName)).bytes;
    final kSigning = Hmac(
      sha256,
      kService,
    ).convert(utf8.encode('aws4_request')).bytes;
    return kSigning;
  }

  Future<void> addComplaint({
    required String description,
    required GeoPoint location,
    File? imageFile,
    File? voiceFile,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        _setError('User ID not found in SharedPreferences');
        _setLoading(false);
        return;
      }

      String complaintId = _generateComplaintId();
      String issueId = _generateIssueId();

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        if (imageFile.lengthSync() > 5 * 1024 * 1024) {
          _setError('Image file is too large (max 5MB)');
          _setLoading(false);
          return;
        }
        final presignedURl = await _generatePresignedUrl(
          'image-$userId-$complaintId',
        );
        imageUrl = await _uploadFileToS3(imageFile, presignedURl);

        if (imageUrl == null) {
          _setLoading(false);
          return;
        }
      }

      // Upload voice recording if provided
      String? voiceUrl;
      if (voiceFile != null) {
        if (voiceFile.lengthSync() > 10 * 1024 * 1024) {
          _setError('Audio file is too large (max 10MB)');
          _setLoading(false);
          return;
        }

        final presignedURl = await _generatePresignedUrl(
          'audio-$userId-$complaintId',
        );

        voiceUrl = await _uploadFileToS3(voiceFile, presignedURl);

        if (voiceUrl == null) {
          _setLoading(false);
          return;
        }
      }

      Map<String, dynamic> complaintData = {
        'complaintId': complaintId,
        'createdAt': FieldValue.serverTimestamp(),
        'description': description,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'userId': userId,
        'imageUrl': imageUrl,
        'voiceUrl': voiceUrl,
        'status': 'Submitted',
        'transcribe': '',
        'translate': '',
        'dept_id': '',
      };

      Map<String, dynamic> issueData = {
        'complaintId': complaintId,
        'createdAt': FieldValue.serverTimestamp(),
        'description': description,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'userId': userId,
        'imageUrl': imageUrl,
        'voiceUrl': voiceUrl,
        'status': 'Submitted',
        'transcribe': '',
        'translate': '',
        'dept_id': '',
        'issue_id': issueId,
      };

      await _firestore
          .collection('complaint_master')
          .doc(complaintId)
          .set(complaintData);

      await _firestore
          .collection('issue_master_tmp')
          .doc(issueId)
          .set(issueData);

      // After successfully adding complaint to Firestore
      await prefs.setString('latestComplaintId', complaintId);

      _setLoading(false);
    } catch (e) {
      _setError('Failed to add complaint: $e');
      _setLoading(false);
    }
  }

  Future<void> fetchUserComplaints() async {
    _setLoading(true);
    _setError(null);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      debugPrint("getting complaints for user $userId");

      if (userId == null) {
        _setError('User ID not found in SharedPreferences');
        _setLoading(false);
        return;
      }

      QuerySnapshot snapshot = await _firestore
          .collection('complaint_master')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _complaints = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch complaints: $e');
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchLatestComplaints() async {
    _setLoading(true);
    _setError(null);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? latestComplaintId = prefs.getString('latestComplaintId');
      debugPrint("getting latest complaint for user $userId");

      if (userId == null) {
        _setError('User ID not found in SharedPreferences');
        _setLoading(false);
        return;
      }

      if (latestComplaintId == null) {
        _setError('No latest complaint ID found in SharedPreferences');
        _setLoading(false);
        return;
      }

      // Fetch that specific complaint by ID
      DocumentSnapshot doc = await _firestore
          .collection('complaint_master')
          .doc(latestComplaintId)
          .get();

      if (doc.exists) {
        _complaints = [doc.data() as Map<String, dynamic>];
      } else {
        _complaints = []; // No complaint found
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch complaints: $e');
      _setLoading(false);
      notifyListeners();
    }
  }
}
