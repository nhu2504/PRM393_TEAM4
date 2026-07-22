import 'package:flutter/material.dart';
import '../controllers/main_controller.dart';
import 'movie_screen.dart';
import 'cinema_screen.dart';
import 'movie_showtimes_screen.dart';
import 'account_screen.dart';
import '../screens/food_combo_screen.dart';
import '../screens/vouchers_screen.dart';
import '../screens/my_tickets_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainController _controller;

  // Danh sách màn hình tương ứng với từng tab
  final List<Widget> _screens = const [
    MovieScreen(),
    MovieShowtimesScreen(), // Thêm lịch chiếu
    CinemaScreen(),
    FoodComboScreen(),
    VouchersScreen(),
    MyTicketsScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = MainController();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _controller.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _controller.currentIndex,
        onDestinationSelected: _controller.changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            selectedIcon: Icon(Icons.movie),
            label: 'Chọn phim',
          ),
          // 2. Thêm một nút bấm  hiển thị "Lịch chiếu" lên thanh Menu dưới cùng
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Lịch chiếu',
          ),
          NavigationDestination(
            icon: Icon(Icons.theaters_outlined),
            selectedIcon: Icon(Icons.theaters),
            label: 'Chọn rạp',
          ),
          NavigationDestination(
            icon: Icon(Icons.fastfood_outlined),
            selectedIcon: Icon(Icons.fastfood),
            label: 'Bắp nước',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer),
            label: 'Khuyến mãi',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_num_outlined),
            selectedIcon: Icon(Icons.confirmation_num),
            label: 'Vé của tôi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}