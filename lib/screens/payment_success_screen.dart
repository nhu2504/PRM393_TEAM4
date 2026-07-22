import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../views/main_screen.dart';
import 'my_tickets_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Ticket ticket;

  const PaymentSuccessScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white, size: 100),
                const SizedBox(height: 24),
                const Text(
                  'THANH TOÁN THÀNH CÔNG!',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mã vé: ${ticket.id}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),
                
                // Vé demo nhỏ
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(ticket.movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Rạp:', style: TextStyle(color: Colors.grey)),
                          Text(ticket.cinemaName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Thời gian:', style: TextStyle(color: Colors.grey)),
                          Text('${ticket.showTime} | ${ticket.showDate}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Ghế:', style: TextStyle(color: Colors.grey)),
                          Text(ticket.seats.map((s) => s.id).join(', '), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lưu vé vào mock data
                      MyTicketsScreen.globalTickets.insert(0, {
                        'title': ticket.movie.title,
                        'theater': ticket.cinemaName,
                        'time': '${ticket.showTime} - ${ticket.showDate}',
                        'seat': ticket.seats.map((s) => s.id).join(', '),
                        'poster': ticket.movie.image,
                        'status': 'upcoming'
                      });

                      // Quay về trang chủ
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('VỀ TRANG CHỦ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
