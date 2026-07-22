import 'package:flutter/material.dart';

class RatingController extends ChangeNotifier {
  int _currentStar = 5; // Mặc định cho 5 sao
  String _comment = '';
  bool isSubmitting = false;

  int get currentStar => _currentStar;
  String get comment => _comment;

  // Cập nhật số sao khi người dùng vuốt hoặc chạm vào thanh sao
  void updateStar(int star) {
    if (star >= 1 && star <= 5) {
      _currentStar = star;
      notifyListeners(); // Cập nhật UI thanh sao
    }
  }

  // Cập nhật nội dung text bình luận
  void updateComment(String text) {
    _comment = text;
  }

  // Hàm gửi đánh giá lên server
  Future<bool> submitRating(String movieId) async {
    isSubmitting = true;
    notifyListeners(); // Khóa nút Gửi để tránh bấm nhiều lần

    try {
      // TODO: Gọi API gửi rating (_currentStar) và comment (_comment)
      await Future.delayed(const Duration(seconds: 1)); // Giả lập mạng

      isSubmitting = false;
      notifyListeners();
      return true; // Thành công
    } catch (e) {
      debugPrint('Lỗi gửi đánh giá: $e');
      isSubmitting = false;
      notifyListeners();
      return false; // Thất bại
    }
  }
}