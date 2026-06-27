import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../controllers/booking_controller.dart';
import '../screens/seat_selection_screen.dart';

class MovieShowtimesScreen extends StatefulWidget {
  const MovieShowtimesScreen({super.key});

  @override
  State<MovieShowtimesScreen> createState() => _MovieShowtimesScreenState();
}

class _MovieShowtimesScreenState extends State<MovieShowtimesScreen> {
  late final List<DateTime> days;

  final List<String> cinemaFilters = ['Tất cả rạp', 'CGV Cinema', 'BHD Star', 'Lotte Cinema'];

  int selectedDayIndex = 0;
  String selectedCinema = 'Tất cả rạp';

  final List<Map<String, dynamic>> mockMoviesData = [
    {
      'title': 'Avengers: Endgame',
      'genre': 'Hành động, Viễn tưởng',
      'duration': '181 phút',
      'cinemas': [
        {
          'brand': 'CGV Cinema',
          'name': 'CGV Vincom Nguyễn Chí Thanh',
          'address': 'Tầng 5, Vincom Center, Đống Đa',
          'types': [
            {'format': '2D PHỤ ĐỀ', 'times': ['09:30', '12:15', '15:00', '18:45', '21:30']},
            {'format': '3D PHỤ ĐỀ', 'times': ['14:00', '19:30']}
          ]
        },
        {
          'brand': 'BHD Star',
          'name': 'BHD Star Phạm Ngọc Thạch',
          'address': 'Tầng 8, Vincom Phạm Ngọc Thạch',
          'types': [
            {'format': '2D PHỤ ĐỀ', 'times': ['10:00', '13:15', '16:30', '20:00']}
          ]
        }
      ]
    },
    {
      'title': 'Lật Mặt 7: Một Điều Ước',
      'genre': 'Tâm lý, Gia đình',
      'duration': '138 phút',
      'cinemas': [
        {
          'brand': 'Lotte Cinema',
          'name': 'Lotte Cinema Minh Khai',
          'address': 'Tầng 3, Plaza Minh Khai, Hai Bà Trưng',
          'types': [
            {'format': '2D THUYẾT MINH', 'times': ['08:15', '11:00', '14:30', '17:15', '20:45']}
          ]
        },
        {
          'brand': 'CGV Cinema',
          'name': 'CGV Vincom Nguyễn Chí Thanh',
          'address': 'Tầng 5, Vincom Center, Đống Đa',
          'types': [
            {'format': '2D THUYẾT MINH', 'times': ['11:15', '16:00', '21:00']}
          ]
        }
      ]
    },
    {
      'title': 'Frozen 2',
      'genre': 'Hoạt hình, Phiêu lưu',
      'duration': '103 phút',
      'cinemas': [
        {
          'brand': 'BHD Star',
          'name': 'BHD Star Phạm Ngọc Thạch',
          'address': 'Tầng 8, Vincom Phạm Ngọc Thạch',
          'types': [
            {'format': '2D LỒNG TIẾNG', 'times': ['09:00', '11:15', '13:30', '15:45']}
          ]
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    days = List.generate(7, (index) => today.add(Duration(days: index)));
  }

  String _weekdayLabel(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Th 2';
      case DateTime.tuesday:
        return 'Th 3';
      case DateTime.wednesday:
        return 'Th 4';
      case DateTime.thursday:
        return 'Th 5';
      case DateTime.friday:
        return 'Th 6';
      case DateTime.saturday:
        return 'Th 7';
      case DateTime.sunday:
        return 'CN';
      default:
        return 'Th';
    }
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDate(DateTime date) => '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Lịch chiếu phim toàn quốc',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final isSelected = selectedDayIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedDayIndex = index),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey.shade200,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.18),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (index == 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withValues(alpha: 0.18) : Colors.red.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Hôm nay',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.red,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Text(
                          _weekdayLabel(days[index]),
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _twoDigits(days[index].day),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12, top: 4),
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cinemaFilters.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final filterName = cinemaFilters[index];
                final isSelected = selectedCinema == filterName;
                return GestureDetector(
                  onTap: () => setState(() => selectedCinema = filterName),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filterName,
                        style: TextStyle(
                          color: isSelected ? Colors.red : Colors.grey[800],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: mockMoviesData.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final movie = mockMoviesData[index];
                final filteredCinemas = (movie['cinemas'] as List).where((cinema) {
                  if (selectedCinema == 'Tất cả rạp') return true;
                  return cinema['brand'] == selectedCinema;
                }).toList();

                if (filteredCinemas.isEmpty) {
                  return const SizedBox.shrink();
                }

                return _buildMovieSection(movie, filteredCinemas);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection(Map<String, dynamic> movie, List<dynamic> cinemas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                      image: NetworkImage(movie['image'] ?? 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['title'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${movie['genre']} • ${movie['duration']}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cinemas.length,
            itemBuilder: (context, cIndex) {
              final cinema = cinemas[cIndex];
              return _buildCinemaShowtimes(movie, cinema);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaShowtimes(Map<String, dynamic> movie, Map<String, dynamic> cinema) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.theaters, size: 16, color: Colors.red),
              const SizedBox(width: 6),
              Text(
                cinema['name'],
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            cinema['address'],
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
          const SizedBox(height: 12),
          ...List.generate(cinema['types'].length, (tIndex) {
            final type = cinema['types'][tIndex];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type['format'],
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (type['times'] as List<String>).map((time) {
                      return GestureDetector(
                        onTap: () {
                          final movieObj = Movie(
                            id: movie['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
                            title: movie['title'] ?? 'Phim hay',
                            image: movie['image'] ?? 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500',
                            genre: movie['genre'] ?? 'Hành động',
                            categoryId: movie['categoryId']?.toString() ?? '1',
                            status: movie['status'] ?? 'now_showing',
                            durationMinutes: movie['durationMinutes'] ?? 120,
                            releaseDate: movie['releaseDate'] ?? '01/01/2026',
                            description: movie['description'] ?? '',
                          );
                          final controller = BookingController(
                            movie: movieObj,
                            cinemaName: cinema['name'],
                            showDate: _formatDate(days[selectedDayIndex]),
                            showTime: time,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SeatSelectionScreen(controller: controller)),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            time,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 20, color: Colors.black12),
        ],
      ),
    );
  }
}
