import 'package:flutter/material.dart';
import 'movie_showtimes_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isExpanded = false; // Biến trạng thái để thu gọn/mở rộng nội dung phim

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 1. Toàn bộ nội dung cuộn của màn hình chi tiết
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieHeader(context),
                const SizedBox(height: 20),
                _buildMovieInfoSection(),
                const SizedBox(height: 20),
                _buildStorylineSection(),
                const SizedBox(height: 20),
                _buildCastSection(),
                const SizedBox(height: 100), // Khoảng trống để không bị nút "Mua vé" che mất nội dung
              ],
            ),
          ),

          // 2. Nút Back cố định ở góc trên bên trái (để luôn bấm được khi cuộn)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 3. Nút Mua Vé Cố Định Dưới Đáy Màn Hình (Sticky Bottom Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MovieShowtimesScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text(
                  'MUA VÉ NGAY',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget 1: Phần Banner và Poster lồng ghép đè lên nhau ở đỉnh màn hình
  Widget _buildMovieHeader(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // Ảnh Backdrop nền lớn (Giả lập mờ phía sau)
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/600x300'), // Thay bằng ảnh thật sau
                fit: BoxFit.cover,
              ),
            ),
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.grey[100]!,
                ],
              ),
            ),
          ),

          // Poster Phim nổi bật đẩy dịch xuống dưới
          Positioned(
            left: 20,
            bottom: 0,
            child: Container(
              width: 110,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/200x300'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Tên phim và Tag phân loại đặt cạnh Poster
          Positioned(
            left: 146,
            bottom: 10,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avengers: Endgame',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('T16', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('2D | IMAX 3D', style: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget 2: Phần hiển thị các chi tiết thông số phim dạng thẻ ngang (Thời lượng, Điểm, Thể loại)
  Widget _buildMovieInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(Icons.star_rounded, '4.8/5', 'Đánh giá', iconColor: Colors.amber),
            Container(width: 1, height: 30, color: Colors.grey[200]),
            _buildInfoItem(Icons.access_time_rounded, '181 phút', 'Thời lượng'),
            Container(width: 1, height: 30, color: Colors.grey[200]),
            _buildInfoItem(Icons.movie_filter_rounded, 'Hành động', 'Thể loại'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle, {Color iconColor = Colors.grey}) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }

  // Widget 3: Tóm tắt nội dung phim phim (Storyline) kèm chức năng thu gọn/mở rộng thông minh
  Widget _buildStorylineSection() {
    const textContent = 'Sau sự kiện tàn khốc trong Avengers: Cuộc Chiến Vô Cực (2018), vũ trụ đang rơi vào cảnh hoang tàn đổ nát do cú búng tay định mệnh của Thanos. Với sự trợ giúp của các đồng minh còn sống sót, các siêu anh hùng Avengers phải một lần nữa tập hợp lại nhằm đảo ngược hành động của gã ác nhân khét tiếng và khôi phục lại trật tự cho toàn vũ trụ, bất chấp mọi hậu quả.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nội dung phim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            Text(
              textContent,
              style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
              maxLines: isExpanded ? null : 3,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.red,
                      size: 18,
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

  // Widget 4: Diễn viên (Cast) dạng Avatar tròn trượt ngang thông dụng
  Widget _buildCastSection() {
    final List<Map<String, String>> cast = [
      {'name': 'Robert Downey Jr.', 'role': 'Iron Man'},
      {'name': 'Chris Evans', 'role': 'Captain America'},
      {'name': 'Chris Hemsworth', 'role': 'Thor'},
      {'name': 'Scarlett Johansson', 'role': 'Black Widow'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Diễn viên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const NetworkImage('https://via.placeholder.com/100'),
                    ),
                    const SizedBox(height: 6),
                    Text(cast[index]['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(cast[index]['role']!, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
