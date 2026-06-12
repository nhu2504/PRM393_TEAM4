import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  const CinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Rạp', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Danh sách rạp phim sẽ hiển thị ở đây'),
      ),
    );
  }
}