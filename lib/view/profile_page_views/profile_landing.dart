import 'package:civic_service_app/view/authentication_views/authentication_landing.dart';
import 'package:civic_service_app/view/profile_page_views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User NOT logged in → go to Login / Signup page
        if (!snapshot.hasData) {
          return const AuthenticationLanding();
        }

        // User IS logged in → show ProfileView
        return const ProfileView();
      },
    );
  }
}
