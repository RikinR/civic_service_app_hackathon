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
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';
import 'package:civic_service_app/providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterUserViewModel()),
        ChangeNotifierProvider(create: (context) => ComplaintViewModel()),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ), // Add LanguageProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: languageProvider.locale,
          supportedLocales: const [Locale('en'), Locale('hi'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // home: const SecurityCheckPage(),
          home: AppLanding(),
        );
      },
    );
  }
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
          MaterialPageRoute(builder: (_) => const AppLanding()),
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
        title: Text(AppLocalizations.of(context)!.translate('security_alert')),
        content: Text(
          AppLocalizations.of(context)!.translate('security_alert_message'),
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
            child: Text(AppLocalizations.of(context)!.translate('exit')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.translate('checking_security')),
          ],
        ),
      ),
    );
  }
}
