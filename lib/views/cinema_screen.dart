import 'package:flutter/material.dart';
import '../controllers/cinema_controller.dart';
import '../models/cinema_model.dart';
import 'cinema_detail_screen.dart';
import 'movie_showtimes_screen.dart';

class CinemaScreen extends StatefulWidget {
  const CinemaScreen({super.key});

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {
  late final CinemaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CinemaController();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _openCinemaDetail(CinemaModel cinema) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CinemaDetailScreen(cinema: cinema)),
    );
  }

  void _openShowtimes(CinemaModel cinema) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieShowtimesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Chọn rạp', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildFilterChips(_controller.cities, _controller.selectedCity, _controller.onCitySelected),
          const SizedBox(height: 4),
          _buildFilterChips(_controller.brands, _controller.selectedBrand, _controller.onBrandSelected),
          const SizedBox(height: 8),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterChips(List<String> items, String selected, ValueChanged<String> onSelected) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = item == selected;
          return GestureDetector(
            onTap: () => onSelected(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? Colors.red : Colors.grey.shade300),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_controller.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _controller.fetchCinemas, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    if (_controller.cinemas.isEmpty) {
      return const Center(
        child: Text('Không có rạp phù hợp', style: TextStyle(color: Colors.grey)),
      );
    }

    if (_controller.selectedCity == 'Tất cả') {
      final grouped = _controller.cinemasGroupedByCity;
      final cityKeys = grouped.keys.toList();

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: cityKeys.length,
        itemBuilder: (context, index) {
          final city = cityKeys[index];
          final cinemasInCity = grouped[city]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...cinemasInCity.map((cinema) => _CinemaCard(
                cinema: cinema,
                onImageTap: () => _openShowtimes(cinema),
                onCardTap: () => _openCinemaDetail(cinema),
              )),
            ],
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _controller.cinemas.length,
      itemBuilder: (context, index) {
        final cinema = _controller.cinemas[index];
        return _CinemaCard(
          cinema: cinema,
          onImageTap: () => _openShowtimes(cinema),
          onCardTap: () => _openCinemaDetail(cinema),
        );
      },
    );
  }
}

/// Thẻ hiển thị 1 rạp
/// - Bấm vào ẢNH -> mở MovieShowtimesScreen
/// - Bấm vào phần CARD (tên, địa chỉ, nút "Xem chi tiết") -> mở CinemaDetailScreen
class _CinemaCard extends StatelessWidget {
  final CinemaModel cinema;
  final VoidCallback onImageTap;
  final VoidCallback onCardTap;

  const _CinemaCard({
    required this.cinema,
    required this.onImageTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh - bấm vào để mở lịch chiếu
            GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.network(
                      cinema.image,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                    // Badge brand
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          cinema.brand,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Phần thông tin - bấm vào để mở chi tiết rạp
            InkWell(
              onTap: onCardTap,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cinema.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            cinema.address,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.chevron_right, size: 18, color: Colors.red),
                        const SizedBox(width: 2),
                        Text(
                          'Xem chi tiết & chỉ đường',
                          style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
