import 'package:flutter/material.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  static final List<Map<String, dynamic>> globalTickets = [
    {
      'title': 'Dune: Hành Tinh Cát 2',
      'theater': 'CGV Vincom Center',
      'time': '19:30 - 24/04/2026',
      'seat': 'H12, H13',
      'poster': 'https://upload.wikimedia.org/wikipedia/vi/thumb/e/e9/Dune_H%C3%A0nh_tinh_c%C3%A1t_poster.jpg/250px-Dune_H%C3%A0nh_tinh_c%C3%A1t_poster.jpg',
      'status': 'upcoming'
    },
    {
      'title': 'Mai',
      'theater': 'CGV Landmark 81',
      'time': '18:00 - 10/05/2026',
      'seat': 'C05, C06',
      'poster': 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=500',
      'status': 'upcoming'
    },
    {
      'title': 'Lật Mặt 7',
      'theater': 'BHD Star',
      'time': '20:00 - 05/06/2026',
      'seat': 'J01, J02',
      'poster': 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?w=500',
      'status': 'upcoming'
    },
    {
      'title': 'Avengers: Endgame',
      'theater': 'Lotte Cinema',
      'time': '14:00 - 15/02/2026',
      'seat': 'F09, F10',
      'poster': 'https://images.unsplash.com/photo-1608889825103-eb5ed706fc64?w=500',
      'status': 'past'
    },
    {
      'title': 'Spider-Man: No Way Home',
      'theater': 'BHD Star',
      'time': '20:15 - 02/03/2026',
      'seat': 'A01, A02',
      'poster': 'https://image.tmdb.org/t/p/w500/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
      'status': 'past'
    },
    {
      'title': 'Đào, Phở và Piano',
      'theater': 'Trung tâm Chiếu phim QG',
      'time': '10:00 - 20/01/2026',
      'seat': 'G05, G06',
      'poster': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=500',
      'status': 'past'
    }
  ];

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.purpleAccent]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.movie_filter, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                ).createShader(bounds),
                child: const Text(
                  'Vé của tôi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.blueAccent.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                labelColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelColor: Colors.grey[600],
                tabs: const [
                  Tab(text: 'Sắp chiếu'),
                  Tab(text: 'Đã xem'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildTicketList('upcoming'),
            _buildTicketList('past'),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketList(String status) {
    final filteredTickets = MyTicketsScreen.globalTickets.where((t) => t['status'] == status).toList();

    if (filteredTickets.isEmpty) {
      return const Center(child: Text('Không có vé nào.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        return Card(
          elevation: 6,
          shadowColor: Colors.black12,
          margin: const EdgeInsets.only(bottom: 20.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushNamed(context, '/ticket_detail', arguments: ticket);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8FBFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'poster_${ticket['title']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        ticket['poster'],
                        width: 95,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 95,
                          height: 140,
                          color: Colors.grey[300],
                          child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['title'],
                          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.blueAccent),
                            const SizedBox(width: 6),
                            Expanded(child: Text(ticket['theater'], style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled, size: 16, color: Colors.orangeAccent),
                            const SizedBox(width: 6),
                            Text(ticket['time'], style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                                boxShadow: [BoxShadow(color: Colors.blueAccent.withOpacity(0.05), blurRadius: 4)],
                              ),
                              child: Text('Ghế: ${ticket['seat']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueAccent)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: status == 'upcoming' ? Colors.green[50] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status == 'upcoming' ? 'Sắp chiếu' : 'Đã xem',
                                style: TextStyle(
                                  color: status == 'upcoming' ? Colors.green[700] : Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
