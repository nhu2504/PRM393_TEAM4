import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/my_tickets_screen.dart';
import 'views/main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'controllers/account_controller.dart';
import 'controllers/review_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await MyTicketsScreen.globalTicketController.fetchTickets();
    await ReviewController.instance.fetchReviews(); // Thêm nạp reviews khi khởi động
  } catch (e) {
    debugPrint('Lỗi khởi tạo Database: $e');
  }
  runApp(const PopCornGoApp());
}

class PopCornGoApp extends StatelessWidget {
  const PopCornGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // Giữ ScrollBehavior
        scrollBehavior: AppScrollBehavior(),

        // Giữ Theme
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.grey[100],
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),

        // Giữ Route
        initialRoute: '/',

        routes: {
          '/': (context) => const MainScreen(),
          '/ticket_detail': (context) => const TicketDetailScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          // Đã xóa route '/rate' ở đây
        },
      ),
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