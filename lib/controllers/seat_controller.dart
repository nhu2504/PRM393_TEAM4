import 'package:flutter/material.dart';

class SeatController extends ChangeNotifier {
  // Danh sách ID các ghế đang được người dùng chọn (VD: ['A1', 'A2'])
  final List<String> _selectedSeats = [];

  // Giới hạn số ghế tối đa mỗi lần đặt
  final int maxSeats = 6;

  // Giá vé cơ bản (có thể thay đổi tùy loại ghế sau này)
  final double baseTicketPrice = 85000.0;

  // Getter để Views có thể đọc danh sách
  List<String> get selectedSeats => _selectedSeats;

  // Hàm chọn hoặc bỏ chọn ghế
  void toggleSeat(String seatId) {
    if (_selectedSeats.contains(seatId)) {
      _selectedSeats.remove(seatId); // Đã chọn rồi thì bấm vào sẽ bỏ chọn
    } else {
      if (_selectedSeats.length < maxSeats) {
        _selectedSeats.add(seatId); // Chưa vượt quá giới hạn thì thêm vào
      } else {
        // Có thể emit một lỗi hoặc xử lý hiển thị Snackbar bên View
        debugPrint('Chỉ được chọn tối đa $maxSeats ghế');
      }
    }
    notifyListeners(); // Cập nhật lại UI màn hình chọn ghế
  }

  // Hàm tính tổng tiền vé dựa trên số ghế đã chọn
  double get totalSeatPrice {
    return _selectedSeats.length * baseTicketPrice;
  }

  // Làm sạch danh sách ghế (khi thanh toán xong hoặc back lại từ đầu)
  void clearSeats() {
    _selectedSeats.clear();
    notifyListeners();
  }
}