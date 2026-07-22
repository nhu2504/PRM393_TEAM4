import 'package:flutter/material.dart';
import 'package:project_g4/views/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/my_tickets_screen.dart';
import 'views/main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'controllers/account_controller.dart';
import 'controllers/review_controller.dart';
import 'controllers/theme_controller.dart';

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
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // Giữ ScrollBehavior
            scrollBehavior: AppScrollBehavior(),

            // Theme cấu hình
            themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.red,
              scaffoldBackgroundColor: Colors.grey[100],
              fontFamily: 'Roboto',
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                iconTheme: IconThemeData(color: Colors.black87),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.red,
              fontFamily: 'Roboto',
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1E1E1E),
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                iconTheme: IconThemeData(color: Colors.white),
              ),
            ),

            // Giữ Route
            initialRoute: '/onboarding',

            routes: {
              '/': (context) => const MainScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/ticket_detail': (context) => const TicketDetailScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
            },
          );
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