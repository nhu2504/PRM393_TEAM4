// import 'package:flutter/material.dart';
// import 'screens/login_screen.dart';
//
// void main() {
//   runApp(const PopCornGoApp());
// }
//
// class PopCornGoApp extends StatelessWidget {
//   const PopCornGoApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/rate_experience_screen.dart';

void main() {
  runApp(const PopCornGoApp());
}

class PopCornGoApp extends StatelessWidget {
  const PopCornGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/rate': (context) => const RateExperienceScreen(),
        
      },
    );
  }
}