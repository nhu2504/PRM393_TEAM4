import 'package:flutter/material.dart';

class MovieShowtimesScreen extends StatefulWidget {
  const MovieShowtimesScreen({super.key});

  @override
  State<MovieShowtimesScreen> createState() => _MovieShowtimesScreenState();
}

class _MovieShowtimesScreenState extends State<MovieShowtimesScreen> {
  // Giả lập danh sách ngày trong tuần
  final List<Map<String, String>> days = [
    {'day': '13', 'weekday': 'Th 6'},
    {'day': '14', 'weekday': 'Th 7'},
    {'day': '15', 'weekday': 'CN'},
    {'day': '16', 'weekday': 'Th 2'},
    {'day': '17', 'weekday': 'Th 3'},
    {'day': '18', 'weekday': 'Th 4'},
    {'day': '19', 'weekday': 'Th 5'},
  ];

  // Danh sách bộ lọc rạp phim
  final List<String> cinemaFilters = ['Tất cả rạp', 'CGV Cinema', 'BHD Star', 'Lotte Cinema'];

  int selectedDayIndex = 0;
  String selectedCinema = 'Tất cả rạp'; // Biến lưu rạp đang được chọn để lọc

  // Dữ liệu giả lập danh sách phim kèm lịch chiếu tại các rạp
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
          // 1. Thanh lịch ngang chọn ngày
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
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[index]['weekday']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          days[index]['day']!,
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

          // 2. THANH CHỌN RẠP NGANG (MỚI THÊM)
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
                  onTap: () {
                    setState(() {
                      selectedCinema = filterName;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red.withOpacity(0.1) : Colors.white,
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

          // 3. Danh sách phim sau khi lọc theo rạp
          Expanded(
            child: ListView.builder(
              itemCount: mockMoviesData.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final movie = mockMoviesData[index];

                // Lọc danh sách rạp của phim này dựa vào rạp đang chọn ở bộ lọc
                final filteredCinemas = (movie['cinemas'] as List).where((cinema) {
                  if (selectedCinema == 'Tất cả rạp') return true;
                  return cinema['brand'] == selectedCinema;
                }).toList();

                // Nếu phim này không có suất chiếu ở rạp đang chọn, ẩn phim này đi luôn
                if (filteredCinemas.isEmpty) {
                  return const SizedBox.shrink();
                }

                // Nếu có suất, render giao diện phim kèm theo các rạp đã lọc
                return _buildMovieSection(movie, filteredCinemas);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin 1 bộ phim
  Widget _buildMovieSection(Map<String, dynamic> movie, List<dynamic> cinemas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/100x140'),
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

          // Duyệt qua danh sách rạp đã được truyền vào sau khi lọc
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cinemas.length,
            itemBuilder: (context, cIndex) {
              final cinema = cinemas[cIndex];
              return _buildCinemaShowtimes(cinema);
            },
          ),
        ],
      ),
    );
  }

  // Widget hiển thị suất chiếu của từng rạp
  Widget _buildCinemaShowtimes(Map<String, dynamic> cinema) {
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
                      return Container(
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