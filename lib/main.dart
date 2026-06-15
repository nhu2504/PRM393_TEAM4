import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'views/main_screen.dart';
=======

import 'views/main_screen.dart';
import 'screens/ticket_detail_screen.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
      scrollBehavior: AppScrollBehavior(),
=======

      // Giữ ScrollBehavior của bạn kia
      scrollBehavior: AppScrollBehavior(),

      // Giữ Theme của bạn kia
>>>>>>> Stashed changes
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
<<<<<<< Updated upstream
      home: const MainScreen(),
=======

      // Giữ Route của bạn
      initialRoute: '/',

      routes: {
        '/': (context) => const MainScreen(),
        '/ticket_detail': (context) => const TicketDetailScreen(),
      },
>>>>>>> Stashed changes
    );
  }
}

<<<<<<< Updated upstream
/// Custom ScrollBehavior cho phép kéo bằng chuột/trackpad
/// (mặc định Flutter chỉ hỗ trợ kéo bằng touch/stylus)
=======
/// Cho phép kéo bằng chuột, touchpad, bút cảm ứng,...
>>>>>>> Stashed changes
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