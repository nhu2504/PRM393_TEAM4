import 'package:flutter/material.dart';
import '../controllers/ticket_controller.dart';
import '../models/ticket_model.dart';

class MyTicketsScreen extends StatefulWidget {
  final TicketController? ticketController;

  const MyTicketsScreen({super.key, this.ticketController});

  static TicketController globalTicketController = TicketController();

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> with TickerProviderStateMixin {
  late final TicketController _controller;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = widget.ticketController ?? MyTicketsScreen.globalTicketController;
    _controller.addListener(_onChanged);
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _animController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D2B),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 140,
                    floating: false,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: const Color(0xFF0D0D2B),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1A1A4E), Color(0xFF0D0D2B)],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                            child: FadeTransition(
                              opacity: _fadeAnim,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                                          ),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: const Icon(Icons.confirmation_num_rounded, color: Colors.white, size: 26),
                                      ),
                                      const SizedBox(width: 14),
                                      ShaderMask(
                                        shaderCallback: (bounds) => const LinearGradient(
                                          colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                                        ).createShader(bounds),
                                        child: const Text(
                                          'Vé của tôi',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_controller.tickets.length} vé đã đặt',
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white54,
                          tabs: [
                            Tab(text: 'Sắp chiếu (${_controller.upcomingTickets.length})'),
                            Tab(text: 'Đã xem (${_controller.pastTickets.length})'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  _buildTicketList(_controller.upcomingTickets, isUpcoming: true),
                  _buildTicketList(_controller.pastTickets, isUpcoming: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketList(List<Ticket> tickets, {required bool isUpcoming}) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.confirmation_num_outlined : Icons.history_rounded,
              size: 80,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'Bạn chưa có vé nào sắp chiếu' : 'Chưa có lịch sử xem phim',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming ? 'Hãy đặt vé xem phim ngay!' : '',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketCard(ticket, index, isUpcoming);
      },
    );
  }

  Widget _buildTicketCard(Ticket ticket, int index, bool isUpcoming) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isUpcoming
                ? [const Color(0xFF1E1E50), const Color(0xFF2A2A5E)]
                : [const Color(0xFF1A1A35), const Color(0xFF1E1E40)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(context, '/ticket_detail', arguments: ticket),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Hero(
                    tag: 'ticket_poster_${ticket.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        ticket.movie.image,
                        width: 90,
                        height: 130,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 90,
                          height: 130,
                          color: const Color(0xFF2A2A5E),
                          child: const Icon(Icons.movie, size: 36, color: Colors.white24),
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
                          ticket.movie.title,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        _buildInfoChip(Icons.location_on_rounded, ticket.cinemaName, const Color(0xFF4ECDC4)),
                        const SizedBox(height: 6),
                        _buildInfoChip(
                          Icons.access_time_filled_rounded,
                          '${ticket.showTime} | ${ticket.showDate}',
                          const Color(0xFFFFB74D),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Ghế: ${ticket.seats.map((s) => s.id).join(', ')}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isUpcoming ? const Color(0xFF4ECDC4) : Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isUpcoming ? '● Sắp chiếu' : '● Đã xem',
                                style: TextStyle(
                                  color: isUpcoming ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
