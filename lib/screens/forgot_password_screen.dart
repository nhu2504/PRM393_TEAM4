import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'X',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),

                  const SizedBox(width: 55),

                  const Text(
                    '🔐  Forgot Password',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryPink,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your email address and we'll\nsend you a verification code.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const CustomTextField(
                hint: 'Enter email address',
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'Send Verification Code',
                width: 270,
                onPressed: () {},
              ),

              const Spacer(),

              const Text(
                'Remember your password?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff456cff),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}