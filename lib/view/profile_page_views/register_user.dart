// ignore_for_file: use_build_context_synchronously

import 'package:civic_service_app/view/app_landing.dart';
import 'package:civic_service_app/viewmodel/user_viewmodel.dart';
import 'package:civic_service_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();

  String? userId; 
  String? emailId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      emailId = prefs.getString('emailID');

      if (emailId != null) {
        emailController.text = emailId!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              height: height * 0.65,
              width: width * 0.9,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Consumer<RegisterUserViewModel>(
                  builder: (context, vm, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register User",
                          style: TextStyle(
                            color: colorScheme.tertiary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled:
                              userId == null, 
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: aadhaarController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Aadhaar Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        vm.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                function: () async {
                                  await vm.registerUser(
                                    uid:
                                        userId!, 
                                    fullName: fullNameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phoneNo: phoneController.text.trim(),
                                    aadhaarNo: aadhaarController.text.trim(),
                                    context: context,
                                  );

                                  if (vm.error == null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AppLanding(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(vm.error!)),
                                    );
                                  }
                                },
                                label: 'Submit',
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
