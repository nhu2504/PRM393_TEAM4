import 'package:flutter/material.dart';

class PromotionsScreen extends StatelessWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Khuyến mãi', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Danh sách khuyến mãi sẽ hiển thị ở đây'),
      ),
    );
  }
}