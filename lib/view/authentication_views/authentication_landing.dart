import 'package:civic_service_app/view/profile_page_views/profile_view.dart';
import 'package:civic_service_app/viewmodel/auth_view_model.dart';
import 'package:civic_service_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:civic_service_app/l10n/app_localizations.dart';

class AuthenticationLanding extends StatefulWidget {
  const AuthenticationLanding({super.key});

  @override
  State<AuthenticationLanding> createState() => _AuthenticationLandingState();
}

class _AuthenticationLandingState extends State<AuthenticationLanding> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoggedIn = false;
  bool _checkingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
      _checkingLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLogin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isLoggedIn) {
      return const ProfileView();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.tertiary.withAlpha(175),
              colorScheme.primary.withAlpha(50),
              colorScheme.primary.withAlpha(25),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              height: height * 0.45,
              width: width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.translate('sign_up_login'),
                      style: TextStyle(
                        color: colorScheme.tertiary,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(
                          context,
                        )!.translate('email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(
                          context,
                        )!.translate('password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Consumer<AuthViewModel>(
                      builder: (context, authVM, child) {
                        return Column(
                          children: [
                            CustomButton(
                              function: () {
                                authVM.registerWithEmail(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  context,
                                );
                              },
                              label: authVM.isLoading
                                  ? AppLocalizations.of(
                                      context,
                                    )!.translate('processing')
                                  : AppLocalizations.of(
                                      context,
                                    )!.translate('register'),
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              function: () {
                                authVM
                                    .loginWithEmail(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      context,
                                    )
                                    .then((_) {
                                      if (!mounted) return; // ✅ Prevent crash
                                      setState(() {
                                        _isLoggedIn =
                                            FirebaseAuth.instance.currentUser !=
                                            null;
                                      });
                                    });
                              },
                              label: authVM.isLoading
                                  ? AppLocalizations.of(
                                      context,
                                    )!.translate('checking')
                                  : AppLocalizations.of(
                                      context,
                                    )!.translate('login'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
