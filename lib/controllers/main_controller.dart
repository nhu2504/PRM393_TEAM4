import 'package:flutter/material.dart';

/// Quản lý trạng thái tab đang chọn ở thanh điều hướng dưới cùng
class MainController extends ChangeNotifier {
  int currentIndex = 0;

  void changeTab(int index) {
    if (currentIndex == index) return;
    currentIndex = index;
    notifyListeners();
  }
}