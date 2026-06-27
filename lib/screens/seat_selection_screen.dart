import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/seat_model.dart';
import 'booking_food_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final BookingController controller;

  const SeatSelectionScreen({super.key, required this.controller});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
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

  String _formatCurrency(int amount) {
    final str = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(str[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.controller.movie.title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '${widget.controller.cinemaName} | ${widget.controller.showDate} - ${widget.controller.showTime}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF6C63FF).withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Text(
                    'MÀN HÌNH',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), letterSpacing: 2, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: InteractiveViewer(
                  child: Center(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: widget.controller.availableSeats.map(_buildSeat).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLegend(Colors.white.withValues(alpha: 0.2), 'Trống'),
                    _buildLegend(const Color(0xFF6C63FF), 'Đang chọn'),
                    _buildLegend(Colors.white.withValues(alpha: 0.05), 'Đã đặt'),
                    _buildLegend(const Color(0xFFFFB74D), 'VIP'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A4E),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tạm tính', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            '${_formatCurrency(widget.controller.totalAmount)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFFFF9800)),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity: widget.controller.selectedSeats.isEmpty ? 0.4 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: widget.controller.selectedSeats.isNotEmpty
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: widget.controller.selectedSeats.isEmpty
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingFoodScreen(controller: widget.controller),
                                        ),
                                      );
                                    },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                child: Text(
                                  'Tiếp tục',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeat(Seat seat) {
    final isSelected = widget.controller.selectedSeats.contains(seat);
    Color seatColor = Colors.white.withValues(alpha: 0.15);
    Color textColor = Colors.white54;

    if (seat.type == 'vip') {
      seatColor = const Color(0xFFFFB74D).withValues(alpha: 0.3);
      textColor = const Color(0xFFFFB74D);
    }
    if (seat.isBooked) {
      seatColor = Colors.white.withValues(alpha: 0.03);
      textColor = Colors.white24;
    }
    if (isSelected) {
      seatColor = const Color(0xFF6C63FF);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => widget.controller.toggleSeatSelection(seat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : seat.type == 'vip'
                    ? const Color(0xFFFFB74D).withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.08),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            seat.id,
            style: TextStyle(
              color: textColor,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
      ],
    );
  }
}
