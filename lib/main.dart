// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:civic_service_app/core/theme.dart';
import 'package:civic_service_app/view/app_landing.dart';
import 'package:civic_service_app/viewmodel/auth_view_model.dart';
import 'package:civic_service_app/viewmodel/complaint_viewmodel.dart';
import 'package:civic_service_app/viewmodel/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:safesecurelibs/safesecurelibs.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterUserViewModel()),
        ChangeNotifierProvider(create: (context) => ComplaintViewModel()),
      ],
      // child: MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   theme: AppTheme.lightTheme,
      //   home: const SecurityCheckPage(),
      // ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppLanding(),
      ),
    ),
  );
}

class SecurityCheckPage extends StatefulWidget {
  const SecurityCheckPage({super.key});

  @override
  State<SecurityCheckPage> createState() => _SecurityCheckPageState();
}

class _SecurityCheckPageState extends State<SecurityCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    try {
      final status = await CheckerMethode.checkSecurityStatus();

      if (status['isDevModeEnabled'] == true ||
          status['isRooted'] == true ||
          status['isMagiskDetected'] == true ||
          status['hasDangerousApps'] == true ||
          status['isSecure'] == false) {
        _showSecurityAlert();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AppLanding()),
        );
      }
    } catch (e) {
      print('Security check failed: $e');
      _showSecurityAlert();
    }
  }

  void _showSecurityAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Security Alert'),
        content: const Text(
          'Developer options are enabled or device is rooted/jailbroken. Please disable them to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
