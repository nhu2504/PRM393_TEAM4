import 'package:flutter/material.dart';
import '../models/seat_model.dart';
import '../models/ticket_model.dart';
import '../models/movie_model.dart';
import '../models/voucher_model.dart';
import '../models/food_model.dart';

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
  List<FoodItem> selectedFoods = [];
  
  // Voucher đang áp dụng
  Voucher? appliedVoucher;
  
  // Phương thức thanh toán
  String selectedPaymentMethod = 'Ví MoMo';

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

  // Cập nhật giỏ hàng đồ ăn (từ FoodItem list)
  void updateFoodCart(List<FoodItem> foods) {
    selectedFoods = foods.where((f) => f.qty > 0).toList();
    notifyListeners();
  }

  // Áp dụng voucher
  void applyVoucher(Voucher voucher) {
    appliedVoucher = voucher;
    notifyListeners();
  }

  // Hủy voucher
  void removeVoucher() {
    appliedVoucher = null;
    notifyListeners();
  }

  // Đổi phương thức thanh toán
  void changePaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  // Tính tổng tiền ghế
  int get seatTotal => selectedSeats.fold(0, (sum, seat) => sum + seat.price);

  // Tính tổng tiền đồ ăn
  int get foodTotal => selectedFoods.fold(0, (sum, food) => sum + food.price * food.qty);

  // Tính giảm giá
  int get discountAmount {
    if (appliedVoucher == null) return 0;
    if (seatTotal + foodTotal < appliedVoucher!.minOrderValue) return 0;
    return appliedVoucher!.discountValue;
  }

  // Tính tổng tiền cuối cùng
  int get totalAmount {
    int total = seatTotal + foodTotal - discountAmount;
    return total < 0 ? 0 : total;
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
      foods: selectedFoods.map((f) => f.toMap()).toList(),
      totalAmount: totalAmount,
      bookingDate: DateTime.now().toString(),
    );
  }
}
