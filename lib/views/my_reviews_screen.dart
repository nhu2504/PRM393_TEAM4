import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key}); // Chuẩn code mới

  @override
  Widget build(BuildContext context) {
    // DefaultTabController giúp quản lý trạng thái của các Tab một cách tự động
    return DefaultTabController(
      length: 2, // Số lượng tab
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {}, // TODO: Nút back
          ),
          title: const Text(
            'Lịch sử đánh giá',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // Thanh TabBar ở dưới tiêu đề AppBar
          bottom: TabBar(
            labelColor: Colors.red[600], // Màu chữ khi chọn tab
            unselectedLabelColor: Colors.grey, // Màu chữ khi chưa chọn
            indicatorColor: Colors.red[600], // Màu đường gạch dưới
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Đánh giá Phim'),
              Tab(text: 'Trải nghiệm Rạp'),
            ],
          ),
        ),
        // TabBarView chứa nội dung tương ứng của từng Tab
        body: TabBarView(
          children: [
            _buildMovieReviewsTab(),
            _buildExperienceReviewsTab(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: DANH SÁCH ĐÁNH GIÁ PHIM
  // ==========================================
  Widget _buildMovieReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildReviewCard(
          imageUrl: 'https://picsum.photos/seed/avengers/150/220',
          title: 'Avengers: Endgame',
          date: '24/05/2026',
          rating: 5,
          comment: 'Phim quá đỉnh, kỹ xảo mãn nhãn. Chắc chắn sẽ đi xem lại lần nữa!',
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          imageUrl: 'https://picsum.photos/seed/latmat/150/220',
          title: 'Lật Mặt 7',
          date: '10/05/2026',
          rating: 4,
          comment: 'Nội dung cảm động, diễn viên diễn xuất tốt nhưng đoạn cuối hơi vội.',
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: DANH SÁCH ĐÁNH GIÁ TRẢI NGHIỆM
  // ==========================================
  Widget _buildExperienceReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildReviewCard(
          isExperience: true,
          imageUrl: 'https://picsum.photos/seed/cinema1/150/150', // Dùng ảnh rạp hoặc icon
          title: 'Beta Cinemas Mỹ Đình',
          date: '24/05/2026',
          rating: 3,
          comment: 'Rạp sạch sẽ nhưng nhân viên quầy bắp nước phục vụ hơi chậm. Ghế ngồi thoải mái.',
        ),
        const SizedBox(height: 16),
        _buildReviewCard(
          isExperience: true,
          imageUrl: 'https://picsum.photos/seed/cinema2/150/150',
          title: 'CGV Vincom Center',
          date: '15/04/2026',
          rating: 5,
          comment: 'Dịch vụ tuyệt vời, không gian sảnh chờ check-in sống ảo rất đẹp.',
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET DÙNG CHUNG CHO CẢ 2 LOẠI ĐÁNH GIÁ
  // ==========================================
  Widget _buildReviewCard({
    required String imageUrl,
    required String title,
    required String date,
    required int rating,
    required String comment,
    bool isExperience = false, // Biến cờ để đổi style một chút giữa phim và rạp
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), // Đã sửa withOpacity thành withValues
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh (Poster phim hoặc Ảnh rạp)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: isExperience ? 70 : 60, // Nếu là rạp thì cho ảnh vuông/to hơn chút
              height: isExperience ? 70 : 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),

          // Nội dung text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên phim / Tên rạp và Ngày tháng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Hiển thị số sao
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: index < rating ? Colors.amber : Colors.grey[300],
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 8),

                // Nội dung bình luận
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 3, // Giới hạn dòng để không bị quá dài
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}