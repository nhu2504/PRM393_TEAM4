class OrderModel {
  final String orderId; // Mã đơn hàng
  final String movieId; // Mã phim
  final String cinemaId; // Mã rạp
  final String showtime; // Giờ chiếu
  final List<String> selectedSeats; // Danh sách ID ghế đã chọn
  final double totalAmount; // Tổng tiền
  final DateTime createdAt; // Thời gian đặt vé

  OrderModel({
    required this.orderId,
    required this.movieId,
    required this.cinemaId,
    required this.showtime,
    required this.selectedSeats,
    required this.totalAmount,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] ?? '',
      movieId: json['movieId'] ?? '',
      cinemaId: json['cinemaId'] ?? '',
      showtime: json['showtime'] ?? '',
      selectedSeats: List<String>.from(json['selectedSeats'] ?? []),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'movieId': movieId,
      'cinemaId': cinemaId,
      'showtime': showtime,
      'selectedSeats': selectedSeats,
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}