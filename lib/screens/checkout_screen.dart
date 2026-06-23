import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final BookingController controller;

  const CheckoutScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.redAccent, Colors.orangeAccent],
              ).createShader(bounds),
              child: const Text(
                'Thanh Toán',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin phim
            _buildMovieInfoCard(),
            const SizedBox(height: 16),
            
            // Thông tin thanh toán
            _buildOrderSummaryCard(),
            const SizedBox(height: 16),
            
            // Phương thức thanh toán
            _buildPaymentMethodCard(),
            const SizedBox(height: 40),
            
            InkWell(
              onTap: () {
                final ticket = controller.checkout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => PaymentSuccessScreen(ticket: ticket)),
                  (route) => route.isFirst,
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.redAccent, Colors.orangeAccent]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: const Center(
                  child: Text('XÁC NHẬN THANH TOÁN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(controller.movie.image, width: 80, height: 120, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 120, color: Colors.grey)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(controller.cinemaName, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 4),
                Text('Suất chiếu: ${controller.showTime} | ${controller.showDate}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(
                  'Ghế: ${controller.selectedSeats.map((s) => s.id).join(', ')}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    int seatPrice = controller.selectedSeats.fold(0, (s, seat) => s + seat.price);
    int foodPrice = controller.selectedFoods.fold(0, (s, food) => s + (food['price'] as int) * (food['qty'] as int));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ghế (${controller.selectedSeats.length})', style: TextStyle(color: Colors.grey[700])),
              Text('$seatPrice đ', style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          if (controller.selectedFoods.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bắp nước', style: TextStyle(color: Colors.grey[700])),
                Text('$foodPrice đ', style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          const Divider(height: 24, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng tiền', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${controller.totalAmount} đ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Phương thức thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildPaymentOption(Icons.wallet, 'Ví MoMo', true),
          const Divider(height: 1),
          _buildPaymentOption(Icons.credit_card, 'Thẻ ATM/Visa', false),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, bool isSelected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: isSelected ? Colors.red : Colors.grey),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Colors.red : Colors.grey,
      ),
    );
  }
}
