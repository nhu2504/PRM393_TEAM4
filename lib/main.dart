import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'views/main_screen.dart';
import 'screens/ticket_detail_screen.dart';

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

      // Giữ ScrollBehavior của bạn kia
      scrollBehavior: AppScrollBehavior(),

      // Giữ Theme của bạn kia
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      // Giữ Route của bạn
      initialRoute: '/',

      routes: {
        '/': (context) => const MainScreen(),
        '/ticket_detail': (context) => const TicketDetailScreen(),
      },
    );
  }
}

/// Cho phép kéo bằng chuột, touchpad, bút cảm ứng,...
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