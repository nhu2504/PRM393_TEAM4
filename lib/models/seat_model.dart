// Định nghĩa các trạng thái của ghế
enum SeatStatus { available, booked }

class SeatModel {
  final String id; // Mã ghế (VD: 'A1', 'B2')
  final String row; // Hàng (VD: 'A', 'B')
  final int number; // Số thứ tự (VD: 1, 2)
  final SeatStatus status; // Trạng thái ghế
  final double price; // Giá của ghế này (nếu có ghế VIP giá khác)

  SeatModel({
    required this.id,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
    required this.price,
  });

  // Hàm tạo Object từ dữ liệu JSON (khi gọi API lấy danh sách ghế)
  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] ?? '',
      row: json['row'] ?? '',
      number: json['number'] ?? 0,
      status: json['isBooked'] == true ? SeatStatus.booked : SeatStatus.available,
      price: (json['price'] ?? 85000).toDouble(),
    );
  }

  // Chuyển Object thành JSON (nếu cần gửi lên server)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row': row,
      'number': number,
      'isBooked': status == SeatStatus.booked,
      'price': price,
    };
  }
}