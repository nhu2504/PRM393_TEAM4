import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../screens/my_tickets_screen.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({Key? key}) : super(key: key);

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
    // Nhận dữ liệu ticket từ Navigator
    final ticket = ModalRoute.of(context)?.settings.arguments as Ticket?;

    if (ticket == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D0D2B),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D2B),
          title: const Text('Chi tiết vé', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('Không tìm thấy thông tin vé', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Chi tiết vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Poster phim
            Stack(
              children: [
                Hero(
                  tag: 'ticket_poster_${ticket.id}',
                  child: Image.network(
                    ticket.movie.image,
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (_, __, ___) => Container(
                      height: 350,
                      color: const Color(0xFF1A1A4E),
                      child: const Center(child: Icon(Icons.movie, color: Colors.white24, size: 60)),
                    ),
                  ),
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        const Color(0xFF0D0D2B),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ],
            ),

            // Ticket card
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
                        ),
                        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // Tên phim
                                Text(
                                  ticket.movie.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow('Rạp', ticket.cinemaName, Icons.location_on_rounded, const Color(0xFF4ECDC4)),
                                _buildInfoRow('Suất chiếu', '${ticket.showTime} | ${ticket.showDate}', Icons.access_time_filled_rounded, const Color(0xFFFFB74D)),
                                _buildInfoRow('Ghế', ticket.seats.map((s) => s.id).join(', '), Icons.event_seat_rounded, const Color(0xFF6C63FF)),
                                _buildInfoRow('Phòng chiếu', 'Cinema 03', Icons.meeting_room_rounded, const Color(0xFF4ECDC4)),
                                if (ticket.foods.isNotEmpty)
                                  _buildInfoRow(
                                    'Đồ ăn',
                                    ticket.foods.map((f) => '${f['name']} x${f['qty']}').join(', '),
                                    Icons.fastfood_rounded,
                                    const Color(0xFFFF9800),
                                  ),
                              ],
                            ),
                          ),

                          // Dashed divider
                          Row(
                            children: List.generate(
                              40,
                              (index) => Expanded(
                                child: Container(
                                  height: 2,
                                  color: index % 2 == 0 ? Colors.transparent : Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ),
                          ),

                          // QR Code + Tổng tiền
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                // QR
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.qr_code_2, size: 130, color: Color(0xFF0D0D2B)),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Mã vé: ${ticket.id.substring(ticket.id.length - 8)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Tổng tiền
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Tổng: ${_formatCurrency(ticket.totalAmount)}đ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Nút hủy vé
                    SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            _showCancelDialog(context, ticket);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.4)),
                              color: const Color(0xFFFF6B6B).withOpacity(0.08),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cancel_outlined, color: Color(0xFFFF6B6B), size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Hủy vé',
                                  style: TextStyle(fontSize: 16, color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xác nhận hủy vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Bạn có chắc chắn muốn hủy vé "${ticket.movie.title}" không?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Không', style: TextStyle(color: Colors.white.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              MyTicketsScreen.globalTicketController.cancelTicket(ticket.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Đã hủy vé thành công'),
                  backgroundColor: const Color(0xFF4ECDC4),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Hủy vé', style: TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
