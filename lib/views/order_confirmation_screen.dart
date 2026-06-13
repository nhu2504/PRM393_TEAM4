import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Màu nền hơi xám nhẹ để làm nổi bật các thẻ (Card) trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {}, // TODO: Xử lý nút back
        ),
        title: const Text(
          'Xác nhận đơn hàng',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Khối thông tin Phim
              _buildMovieInfoCard(),
              const SizedBox(height: 16),

              // 2. Khối thông tin Đặt vé (Rạp, Ghế, Thời gian)
              _buildBookingDetailsCard(),
              const SizedBox(height: 16),

              // 3. Khối thông tin Thanh toán (Tạm tính, Khuyến mãi)
              _buildPaymentSummaryCard(),
              const SizedBox(height: 32), // Khoảng trống ở cuối để không bị che bởi thanh bottom
            ],
          ),
        ),
      ),

      // 4. Thanh toán cố định ở dưới cùng (Giống hệt màn Chọn ghế cho đồng bộ)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tổng thanh toán', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 4),
                  Text(
                    '170.000 đ', // Tổng tiền cứng
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {}, // TODO: Xử lý chuyển sang màn hình Thanh toán/Cổng thanh toán
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- CÁC WIDGET PHỤ TRỢ (Tách ra cho code dễ nhìn) ---

  // Khối 1: Thông tin phim
  Widget _buildMovieInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh poster phim (Dùng link ảnh mock)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://picsum.photos/seed/avengers/150/220',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Thông tin Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avengers: Endgame',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Thể loại: Hành động, Viễn tưởng', style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 4),
                Text('Định dạng: 2D Phụ đề', style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 4),
                Text('Thời lượng: 181 phút', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Khối 2: Chi tiết đặt chỗ (Rạp, Ghế...)
  Widget _buildBookingDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.location_on_outlined, 'Rạp chiếu', 'Beta Cinemas Mỹ Đình'),
          const Divider(height: 24),
          _buildInfoRow(Icons.calendar_month_outlined, 'Thời gian', '14:15 - Thứ 6, 24/05'),
          const Divider(height: 24),
          _buildInfoRow(Icons.meeting_room_outlined, 'Phòng chiếu', 'Phòng 03'),
          const Divider(height: 24),
          _buildInfoRow(Icons.event_seat_outlined, 'Ghế đã chọn', 'E4, E5', isHighlight: true),
        ],
      ),
    );
  }

  // Khối 3: Tóm tắt thanh toán
  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết thanh toán',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPriceRow('Ghế thường (2x)', '170.000 đ'),
          const SizedBox(height: 8),
          _buildPriceRow('Combo Bắp Nước', '0 đ'), // Phần này của bạn Nam sẽ ghép vào sau
          const SizedBox(height: 8),
          _buildPriceRow('Giảm giá (Voucher)', '- 0 đ', valueColor: Colors.green),
          const Divider(height: 24),
          _buildPriceRow('Tổng cộng', '170.000 đ', isTotal: true),
        ],
      ),
    );
  }

  // Hàm tạo dòng thông tin có Icon
  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? Colors.red[600] : Colors.black,
          ),
        ),
      ],
    );
  }

  // Hàm tạo dòng giá tiền
  Widget _buildPriceRow(String label, String price, {bool isTotal = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? (isTotal ? Colors.red : Colors.black),
          ),
        ),
      ],
    );
  }
}