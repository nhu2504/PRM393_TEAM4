import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Tôi', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Thông tin tài khoản sẽ hiển thị ở đây'),
      ),
    );
  }
}