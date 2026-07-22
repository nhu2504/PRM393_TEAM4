import 'package:flutter/material.dart';

class OrderController extends ChangeNotifier {
  bool isLoading = false; // Trạng thái màn hình loading khi bấm thanh toán

  // Hàm xử lý xác nhận đơn hàng
  Future<bool> confirmOrder({
    required List<String> selectedSeats,
    required double totalPrice,
    // Sau này có thể truyền thêm paymentMethod, voucherId...
  }) async {
    if (selectedSeats.isEmpty) return false;

    isLoading = true;
    notifyListeners(); // Hiện loading spinner trên màn hình Xác nhận

    try {
      // TODO: Tích hợp gọi API lên backend hoặc cổng thanh toán tại đây
      // Giả lập thời gian chờ mạng 2 giây
      await Future.delayed(const Duration(seconds: 2));

      // Xử lý thành công
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      // Xử lý lỗi (hết thời gian giữ ghế, lỗi mạng, v.v.)
      debugPrint('Lỗi xác nhận đơn hàng: $error');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}