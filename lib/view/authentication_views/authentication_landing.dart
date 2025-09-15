
import 'package:civic_service_app/view/authentication_views/verify_otp.dart';
import 'package:civic_service_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationLanding extends StatelessWidget {
  const AuthenticationLanding({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final TextEditingController phoneNumberController = TextEditingController();
    final FocusNode phoneFocusNode = FocusNode();

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
              height: height * 0.3,
              width: width * 0.9,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: colorScheme.tertiary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Expanded(
                      child: TextFormField(
                        controller: phoneNumberController,
                        focusNode: phoneFocusNode,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                        ],
                        decoration: InputDecoration(
                          prefix: Text('+91-'),
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length < 10) {
                            return 'Phone number must be at least 10 digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerifyOtp()),
                      );
                    },
                    label: 'Verify Phone Number',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}