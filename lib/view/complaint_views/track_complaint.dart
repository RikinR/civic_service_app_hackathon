import 'package:civic_service_app/view/complaint_views/complaint_status_view.dart';
import 'package:civic_service_app/view/profile_page_views/profile_landing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintStatusWrapper extends StatelessWidget {
  const ComplaintStatusWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking Firebase
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User NOT logged in → show Login page
        if (!snapshot.hasData) {
          return const ProfileWrapper();
        }

        // User IS logged in → show ComplaintStatusView
        return const ComplaintStatusView();
      },
    );
  }
}
