import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String cinemaName;
  final String showtime;
  final List<String> selectedSeats;
  final int totalAmount;

  const OrderConfirmationScreen({
    super.key,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final OrderController _controller = OrderController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _handlePayment() async {
    bool success = await _controller.confirmOrder(
      selectedSeats: widget.selectedSeats,
      totalPrice: widget.totalAmount.toDouble(),
    );

    if (success && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text('Thanh toán thành công!', textAlign: TextAlign.center),
            ],
          ),
          content: const Text(
            'Vé của bạn đã được xác nhận. Chúc bạn xem phim vui vẻ!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('VỀ TRANG CHỦ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
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
                  _buildMovieInfoCard(),
                  const SizedBox(height: 16),
                  _buildBookingDetailsCard(),
                  const SizedBox(height: 16),
                  _buildPaymentSummaryCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tổng thanh toán', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.totalAmount.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.red),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _controller.isLoading ? null : _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _controller.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Thanh toán',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_controller.isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator(color: Colors.red)),
          ),
      ],
    );
  }

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

  Widget _buildBookingDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.location_on_outlined, 'Rạp chiếu', widget.cinemaName),
          const Divider(height: 24),
          _buildInfoRow(Icons.calendar_month_outlined, 'Thời gian', widget.showtime),
          const Divider(height: 24),
          _buildInfoRow(Icons.meeting_room_outlined, 'Phòng chiếu', 'Phòng 03'),
          const Divider(height: 24),
          _buildInfoRow(Icons.event_seat_outlined, 'Ghế đã chọn', widget.selectedSeats.join(', '), isHighlight: true),
        ],
      ),
    );
  }

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
          _buildPriceRow('Ghế (${widget.selectedSeats.length}x)', '${widget.totalAmount.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")} đ'),
          const SizedBox(height: 8),
          _buildPriceRow('Combo Bắp Nước', '0 đ'),
          const SizedBox(height: 8),
          _buildPriceRow('Giảm giá (Voucher)', '- 0 đ', valueColor: Colors.green),
          const Divider(height: 24),
          _buildPriceRow('Tổng cộng', '${widget.totalAmount.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")} đ', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
              color: isHighlight ? Colors.red[600] : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

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