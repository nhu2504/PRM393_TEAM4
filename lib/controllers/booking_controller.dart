import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import '../models/ticket_model.dart';
import '../models/movie_model.dart';

class BookingController extends ChangeNotifier {
  // Thông tin suất chiếu
  final Movie movie;
  final String cinemaName;
  final String showDate;
  final String showTime;

  // Danh sách ghế của suất chiếu (Mock)
  List<Seat> availableSeats = [];
  
  // Trạng thái đơn hàng
  List<Seat> selectedSeats = [];
  List<Map<String, dynamic>> selectedFoods = [];

  BookingController({
    required this.movie,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
  }) {
    _initMockSeats();
  }

  void _initMockSeats() {
    List<String> rows = ['A', 'B', 'C', 'D', 'E'];
    for (String row in rows) {
      for (int i = 1; i <= 8; i++) {
        String type = (row == 'D' || row == 'E') ? 'vip' : 'standard';
        int price = type == 'vip' ? 120000 : 90000;
        bool isBooked = (row == 'B' && (i == 3 || i == 4)) || (row == 'C' && i == 5); // Vài ghế đã bị đặt
        
        availableSeats.add(Seat(
          id: '$row$i',
          row: row,
          number: i,
          type: type,
          price: price,
          isBooked: isBooked,
        ));
      }
    }
  }

  // Chọn hoặc bỏ chọn ghế
  void toggleSeatSelection(Seat seat) {
    if (seat.isBooked) return;
    
    if (selectedSeats.contains(seat)) {
      selectedSeats.remove(seat);
    } else {
      selectedSeats.add(seat);
    }
    notifyListeners();
  }

  // Cập nhật giỏ hàng đồ ăn
  void updateFoodCart(List<Map<String, dynamic>> foods) {
    selectedFoods = foods.where((f) => (f['qty'] as int) > 0).toList();
    notifyListeners();
  }

  // Tính tổng tiền
  int get totalAmount {
    int seatTotal = selectedSeats.fold(0, (sum, seat) => sum + seat.price);
    int foodTotal = selectedFoods.fold(0, (sum, food) => sum + (food['price'] as int) * (food['qty'] as int));
    return seatTotal + foodTotal;
  }

  // Giả lập thanh toán và sinh vé
  Ticket checkout() {
    return Ticket(
      id: 'TICKET_${DateTime.now().millisecondsSinceEpoch}',
      movie: movie,
      cinemaName: cinemaName,
      showDate: showDate,
      showTime: showTime,
      seats: List.from(selectedSeats),
      foods: List.from(selectedFoods),
      totalAmount: totalAmount,
      bookingDate: DateTime.now().toString(),
    );
  }
}
