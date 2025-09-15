import 'package:civic_service_app/view/complaint_views/add_complaint_view.dart';
import 'package:civic_service_app/view/profile_page_views/profile_landing.dart';
import 'package:civic_service_app/view/profile_page_views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddComplaintWrapper extends StatelessWidget {
  const AddComplaintWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Waiting for Firebase to check auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is NOT logged in
        if (!snapshot.hasData) {
          return const ProfileWrapper();
        }

        // User IS logged in -> show AddComplaintView
        return const AddComplaintView();
      },
    );
  }
}
