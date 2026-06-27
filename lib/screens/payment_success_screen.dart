import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../views/main_screen.dart';
import 'my_tickets_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Ticket ticket;

  const PaymentSuccessScreen({super.key, required this.ticket});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _fadeController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    MyTicketsScreen.globalTicketController.addTicket(widget.ticket);
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4ECDC4), Color(0xFF44B09E)],
                        ),
                        boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF4ECDC4), Color(0xFF6C63FF)],
                          ).createShader(bounds),
                          child: const Text(
                            'THANH TOÁN THÀNH CÔNG!',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mã vé: ${widget.ticket.id.substring(widget.ticket.id.length - 8)}',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
                        ),
                        border: Border.all(color: const Color(0xFF4ECDC4).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  widget.ticket.movie.title,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                _buildDetailRow('Rạp', widget.ticket.cinemaName, Icons.location_on_rounded, const Color(0xFF4ECDC4)),
                                _buildDetailRow(
                                  'Suất chiếu',
                                  '${widget.ticket.showTime} | ${widget.ticket.showDate}',
                                  Icons.access_time_filled_rounded,
                                  const Color(0xFFFFB74D),
                                ),
                                _buildDetailRow(
                                  'Ghế',
                                  widget.ticket.seats.map((s) => s.id).join(', '),
                                  Icons.event_seat_rounded,
                                  const Color(0xFF6C63FF),
                                ),
                                if (widget.ticket.foods.isNotEmpty)
                                  _buildDetailRow(
                                    'Đồ ăn',
                                    widget.ticket.foods.map((f) => '${f['name']} x${f['qty']}').join(', '),
                                    Icons.fastfood_rounded,
                                    const Color(0xFFFF9800),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(
                              40,
                              (index) => Expanded(
                                child: Container(
                                  height: 2,
                                  color: index % 2 == 0 ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Tổng thanh toán', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color(0xFFFF6B6B), Color(0xFFFFB74D)],
                                  ).createShader(bounds),
                                  child: Text(
                                    '${_formatCurrency(widget.ticket.totalAmount)}đ',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const MainScreen()),
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF4ECDC4).withValues(alpha: 0.5)),
                              color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.home_rounded, color: Color(0xFF4ECDC4), size: 22),
                                SizedBox(width: 10),
                                Text(
                                  'VỀ TRANG CHỦ',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4ECDC4), letterSpacing: 1),
                                ),
                              ],
                            ),
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
