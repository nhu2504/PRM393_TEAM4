import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'views/main_screen.dart';

void main() {
  runApp(const MovieTicketApp());
}

class MovieTicketApp extends StatelessWidget {
  const MovieTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Đặt vé xem phim',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

/// Custom ScrollBehavior cho phép kéo bằng chuột/trackpad
/// (mặc định Flutter chỉ hỗ trợ kéo bằng touch/stylus)
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
  };
}