// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:civic_service_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUserViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  UserModel? _user;
  UserModel? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> registerUser({
    required String uid,
    required String fullName,
    required String email,
    required String aadhaarNo,
    required String phoneNo,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final userData = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        aadhaarNo: aadhaarNo,
        phoneNo: phoneNo,
        createdAt: DateTime.now(),
      );

      await _firestore.collection("user_master").doc(uid).set(userData.toMap());

      _user = userData;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successfull !")),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isRegistered", true);
      await prefs.setString('fullName', fullName);
      await prefs.setString('phoneNo', fullName);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration unsuccessfull ! Please try again later"),
        ),
      );
      _setLoading(false);
    }
  }

  Future<void> fetchCurrentUser() async {
    _setLoading(true);
    _setError(null);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      debugPrint("fetching user from $userId");

      final doc = await _firestore.collection("user_master").doc(userId).get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.id, doc.data()!);
      } else {
        _setError("User not found");
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
