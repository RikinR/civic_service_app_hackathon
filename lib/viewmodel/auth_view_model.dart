// ignore_for_file: use_build_context_synchronously

import 'package:civic_service_app/view/app_landing.dart';
import 'package:civic_service_app/view/profile_page_views/register_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> registerWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.sendEmailVerification();

      _setLoading(false);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      debugPrint("setting email id $email");
      await prefs.setString("emailID", email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppLanding()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email sent. Please check your inbox."),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error occurred")));
    }
  }

  Future<void> loginWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);

    try {
      debugPrint("🔑 Attempting login with email: $email");

      // Step 1: Sign in
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("✅ Login successful, got UserCredential");

      User? user = userCred.user;

      if (user != null) {
        debugPrint(
          "👤 User UID: ${user.uid}, Email Verified: ${user.emailVerified}",
        );

        // Step 2: Refresh user data
        await user.reload();
        user = _auth.currentUser; // Get the refreshed user
        debugPrint(
          "🔄 Reloaded user: ${user?.uid}, Email Verified: ${user?.emailVerified}",
        );

        if (user == null || !user.emailVerified) {
          _setLoading(false);
          debugPrint("❌ Email not verified or user is null.");

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Email not verified. Please check your inbox and verify.",
                ),
                duration: Duration(seconds: 2),
              ),
            );

            // Wait 2 seconds, then logout
            Future.delayed(const Duration(seconds: 2), () async {
              await _auth.signOut();
              debugPrint(
                "🚪 User signed out after showing verification warning.",
              );
              if (context.mounted) {
                logout(context);
              }
            });
          }
          return;
        }

        // Step 3: Save userId locally
        final String userId = user.uid;
        debugPrint("💾 Saving userId to SharedPreferences: $userId");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", userId);

        // Step 4: Fetch all documents in user_master and check if UID exists
        debugPrint("📡 Fetching all documents from user_master...");
        final QuerySnapshot userMasterSnap = await FirebaseFirestore.instance
            .collection('user_master')
            .get();

        bool userExists = false;
        String? storedUserId = prefs.getString("userId");

        if (storedUserId != null) {
          for (var doc in userMasterSnap.docs) {
            // Compare UID against a field named 'uid' in each document
            try {
              if (doc.get('uid') == storedUserId) {
                userExists = true;
                break;
              }
            } catch (e) {
              // Field 'uid' does not exist in this document, skip
              continue;
            }
          }
        }

        _setLoading(false);
        if (!context.mounted) return;

        if (userExists) {
          debugPrint("✅ User exists in user_master. Navigating to AppLanding.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AppLanding()),
          );
        } else {
          debugPrint(
            "🆕 User does NOT exist in user_master. Navigating to RegisterUser.",
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterUser()),
          );
        }
      } else {
        _setLoading(false);
        debugPrint("⚠️ User is NULL after login.");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed. Please try again.")),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      debugPrint("🔥 FirebaseAuthException: ${e.code} - ${e.message}");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
      }
    } catch (e) {
      _setLoading(false);
      debugPrint("🔥 Unexpected error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error checking user registration: $e")),
        );
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userId");
    await prefs.remove("emailID");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AppLanding()),
    );
  }
}
