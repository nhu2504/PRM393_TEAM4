import 'package:flutter/material.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nhận dữ liệu ticket từ Navigator
    final ticket = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {
      'title': 'Mai',
      'theater': 'CGV Vincom Center',
      'time': '19:30 - 10/05/2026',
      'date': '10/05/2026',
      'seat': 'H12, H13',
      'poster': 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=500',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Chi tiết vé', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'poster_${ticket['title']}',
                  child: Image.network(
                    ticket['poster'],
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent, const Color(0xFFF5F7FA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                ticket['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildInfoRow('Rạp', ticket['theater'], Icons.location_on, Colors.blueAccent),
                            _buildInfoRow('Thời gian', ticket['time'] ?? '19:30 - 24/10/2024', Icons.access_time_filled, Colors.orangeAccent),
                            _buildInfoRow('Ghế', ticket['seat'], Icons.event_seat, Colors.purpleAccent),
                            _buildInfoRow('Phòng chiếu', 'Cinema 03', Icons.meeting_room, Colors.green),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Row(
                                children: List.generate(
                                  30,
                                  (index) => Expanded(
                                    child: Container(
                                      color: index % 2 == 0 ? Colors.transparent : Colors.grey[350],
                                      height: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.grey[300]!, width: 2),
                                    ),
                                    child: const Icon(Icons.qr_code_2, size: 140, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text('Mã vé: 84930284',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 3, color: Colors.black87)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.redAccent.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Xử lý hủy vé
                      },
                      child: const Text('Hủy vé', style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold)),
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

  Widget _buildInfoRow(String label, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
          Expanded(
            child: Text(value, 
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
            ),
          ),
        ],
      ),
    );
  }
}
