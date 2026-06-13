import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  'PopCornGo',
                  style: TextStyle(
                    fontSize: 60,
                    color: AppColors.primaryPink,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 60),

                const CustomTextField(
                  hint: 'Enter email address or phone',
                ),

                const SizedBox(height: 20),

                const CustomTextField(
                  hint: 'Enter password',
                  isPassword: true,
                ),

                const SizedBox(height: 40),

                CustomButton(
                  text: 'Sign in',
                  width: 130,
                  onPressed: () {},
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Recovery Password',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff6c6fa3),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                const Text(
                  'Not a member?',
                  style: TextStyle(fontSize: 20),
                ),

                const SizedBox(height: 20),

                CustomButton(
                  text: 'Register now',
                  width: 190,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}