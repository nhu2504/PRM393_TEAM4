import 'package:flutter/material.dart';

// Đảm bảo import đúng đường dẫn tới 4 file giao diện của bạn
import 'views/seat_screen.dart';
import 'views/order_confirmation_screen.dart';
import 'views/rating_screen.dart';
import 'views/my_reviews_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Đặt Vé - Phần của Dũng',
      debugShowCheckedModeBanner: false, // Ẩn chữ "DEBUG" ở góc phải màn hình
      theme: ThemeData(
        // Cấu hình theme cơ bản giống với phong cách các màn hình đã làm
        primaryColor: Colors.red[600],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      // Đặt màn hình khởi chạy là DevMenuScreen để dễ test
      home: const DevMenuScreen(),
    );
  }
}

// ==========================================
// MÀN HÌNH MENU DÀNH RIÊNG CHO LÚC CODE (DEV MENU)
// ==========================================
class DevMenuScreen extends StatelessWidget {
  const DevMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Test Giao Diện'),
        centerTitle: true,
        backgroundColor: Colors.red[600], // Để appbar menu màu đỏ cho dễ phân biệt
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Nút kéo dài hết chiều ngang
          children: [
            const Text(
              'Chọn màn hình để xem trước:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _buildMenuButton(context, '1. Màn hình Chọn ghế', const SeatScreen()),
            const SizedBox(height: 16),

            _buildMenuButton(context, '2. Xác nhận Đơn hàng', const OrderConfirmationScreen()),
            const SizedBox(height: 16),

            _buildMenuButton(context, '3. Đánh giá Phim', const RatingScreen()),
            const SizedBox(height: 16),

            _buildMenuButton(context, '4. Lịch sử Đánh giá', const MyReviewsScreen()),
          ],
        ),
      ),
    );
  }

  // Hàm tạo nút bấm chuyển trang
  Widget _buildMenuButton(BuildContext context, String title, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        // Lệnh chuyển sang màn hình mới
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey[300]!), // Viền mỏng
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}