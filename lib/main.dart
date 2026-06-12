import 'package:flutter/material.dart';
import 'screens/my_tickets_screen.dart';
import 'screens/ticket_detail_screen.dart';
import 'screens/vouchers_screen.dart';
import 'screens/food_combo_screen.dart';

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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MyTicketsScreen(),
    const VouchersScreen(),
    const FoodComboScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: 'Vé của tôi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Khuyến mãi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Đồ ăn',
          ),
        ],
      ),
    );
  }
}
