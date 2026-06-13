import 'package:flutter/material.dart';
import 'screens/ticket_detail_screen.dart';
import 'views/main_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Đặt Vé',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/ticket_detail': (context) => const TicketDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

