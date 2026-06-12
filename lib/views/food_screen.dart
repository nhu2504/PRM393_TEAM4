import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Bắp nước', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Danh sách combo bắp nước sẽ hiển thị ở đây'),
      ),
    );
  }
}