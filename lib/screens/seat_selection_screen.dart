import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/seat_model.dart';
import 'booking_food_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final BookingController controller;

  const SeatSelectionScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.controller.movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Thông tin rạp & giờ chiếu
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${widget.controller.cinemaName} | ${widget.controller.showDate} - ${widget.controller.showTime}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Màn hình (Screen)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(0.5), Colors.transparent],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: const Center(
              child: Text('MÀN HÌNH', style: TextStyle(color: Colors.white54, letterSpacing: 2)),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Sơ đồ ghế
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: widget.controller.availableSeats.map((seat) => _buildSeat(seat)).toList(),
                ),
              ),
            ),
          ),
          
          // Chú thích
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(Colors.white, 'Trống'),
                const SizedBox(width: 16),
                _buildLegend(Colors.red, 'Đang chọn'),
                const SizedBox(width: 16),
                _buildLegend(Colors.grey.shade800, 'Đã đặt'),
                const SizedBox(width: 16),
                _buildLegend(Colors.orange, 'VIP'),
              ],
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tạm tính', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.controller.totalAmount} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: widget.controller.selectedSeats.isEmpty ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingFoodScreen(controller: widget.controller),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSeat(Seat seat) {
    Color seatColor = Colors.white; // standard trống
    if (seat.type == 'vip') seatColor = Colors.orange; // vip trống
    if (seat.isBooked) seatColor = Colors.grey.shade800;
    if (widget.controller.selectedSeats.contains(seat)) seatColor = Colors.red;

    return GestureDetector(
      onTap: () => widget.controller.toggleSeatSelection(seat),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            seat.id,
            style: TextStyle(
              color: (seat.isBooked || widget.controller.selectedSeats.contains(seat)) ? Colors.white : Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
