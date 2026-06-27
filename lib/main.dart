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
import 'screens/ticket_detail_screen.dart';
import 'screens/rate_experience_screen.dart';
import 'screens/my_tickets_screen.dart';
import 'views/main_screen.dart';
import 'package:flutter/gestures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MyTicketsScreen.globalTicketController.fetchTickets();
  } catch (e) {
    debugPrint('Lỗi khởi tạo Database: $e');
  }
  runApp(const PopCornGoApp());
}

class PopCornGoApp extends StatelessWidget {
  const PopCornGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/rate': (context) => const RateExperienceScreen(),
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
