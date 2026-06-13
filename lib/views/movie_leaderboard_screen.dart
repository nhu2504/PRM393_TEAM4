import 'package:flutter/material.dart';

class MovieLeaderboardScreen extends StatefulWidget {
  const MovieLeaderboardScreen({super.key});

  @override
  State<MovieLeaderboardScreen> createState() => _MovieLeaderboardScreenState();
}

class _MovieLeaderboardScreenState extends State<MovieLeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dữ liệu giả lập danh sách phim trong bảng xếp hạng
  final List<Map<String, dynamic>> rankingMovies = [
    {
      'rank': 1,
      'title': 'Lật Mặt 7: Một Điều Ước',
      'genre': 'Tâm lý, Gia đình',
      'tickets': '145.2K vé',
      'trend': 'up', // up, down, stable
    },
    {
      'rank': 2,
      'title': 'Avengers: Endgame',
      'genre': 'Hành động, Viễn tưởng',
      'tickets': '122.8K vé',
      'trend': 'up',
    },
    {
      'rank': 3,
      'title': 'Thám Tử Lừng Danh Conan',
      'genre': 'Hoạt hình, Trinh thám',
      'tickets': '98.5K vé',
      'trend': 'down',
    },
    {
      'rank': 4,
      'title': 'Doraemon: Bản Giao Hưởng Địa Cầu',
      'genre': 'Hoạt hình, Phiêu lưu',
      'tickets': '64.1K vé',
      'trend': 'stable',
    },
    {
      'rank': 5,
      'title': 'Vây Hãm: Kẻ Trừng Phạt',
      'genre': 'Hành động, Hình sự',
      'tickets': '52.3K vé',
      'trend': 'up',
    },
    {
      'rank': 6,
      'title': 'Inside Out 2',
      'genre': 'Hoạt hình, Hài hước',
      'tickets': '41.7K vé',
      'trend': 'down',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tách riêng Top 3 và các thứ hạng còn lại từ danh sách dữ liệu
    final top3Movies = rankingMovies.take(3).toList();
    final remainingMovies = rankingMovies.skip(3).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Bảng Xếp Hạng Phim Hot',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Theo Ngày'),
            Tab(text: 'Theo Tuần'),
            Tab(text: 'Theo Tháng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardContent(top3Movies, remainingMovies),
          _buildLeaderboardContent(top3Movies, remainingMovies), // Giả lập dữ liệu giống nhau cho các tab
          _buildLeaderboardContent(top3Movies, remainingMovies),
        ],
      ),
    );
  }

  // Hàm build giao diện chính của bảng xếp hạng
  Widget _buildLeaderboardContent(List<Map<String, dynamic>> top3, List<Map<String, dynamic>> remaining) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Khu vực Vinh danh Top 3 (Podium)
          const SizedBox(height: 16),
          _buildTop3Podium(top3),
          const SizedBox(height: 24),

          // 2. Tiêu đề danh sách dưới
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thứ hạng tiếp theo',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              Text(
                'Số vé bán ra',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. Danh sách từ hạng #4 trở đi
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: remaining.length,
            itemBuilder: (context, index) {
              final movie = remaining[index];
              return _buildRankingRow(movie);
            },
          ),
        ],
      ),
    );
  }

  // Giao diện bục vinh danh Top 3 thiết kế cân đối
  Widget _buildTop3Podium(List<Map<String, dynamic>> top3) {
    if (top3.length < 3) return const SizedBox.shrink();

    // Sắp xếp thứ tự hiển thị trên bục: [Hạng 2, Hạng 1, Hạng 3] để tạo hình chữ V ngược chuẩn quốc tế
    final itemRank1 = top3[0];
    final itemRank2 = top3[1];
    final itemRank3 = top3[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Hạng 2 (Bên trái)
        _buildPodiumItem(itemRank2, height: 130, posterWidth: 80, badgeColor: const Color(0xFFC0C0C0)),
        const SizedBox(width: 12),
        // Hạng 1 (Chính giữa - To nhất cao nhất)
        _buildPodiumItem(itemRank1, height: 160, posterWidth: 95, badgeColor: const Color(0xFFFFD700), isTop1: true),
        const SizedBox(width: 12),
        // Hạng 3 (Bên phải)
        _buildPodiumItem(itemRank3, height: 115, posterWidth: 75, badgeColor: const Color(0xFFCD7F32)),
      ],
    );
  }

  // Widget con của từng vị trí trong Top 3
  Widget _buildPodiumItem(Map<String, dynamic> movie, {required double height, required double posterWidth, required Color badgeColor, bool isTop1 = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Ảnh Poster Phim
            Container(
              width: posterWidth,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isTop1 ? Colors.red.withOpacity(0.15) : Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/150x220'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Huy chương đính kèm số thứ hạng đè lên góc dưới poster
            Positioned(
              bottom: -14,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: badgeColor,
                child: Text(
                  '${movie['rank']}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Tên phim thu gọn nếu quá dài
        SizedBox(
          width: posterWidth + 15,
          child: Text(
            movie['title'],
            style: TextStyle(fontSize: isTop1 ? 13 : 12, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          movie['tickets'],
          style: TextStyle(fontSize: 11, color: isTop1 ? Colors.red : Colors.grey[600], fontWeight: isTop1 ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }

  // Dòng hiển thị thứ hạng từ #4 trở đi dạng danh sách nằm ngang
  Widget _buildRankingRow(Map<String, dynamic> movie) {
    IconData trendIcon = Icons.remove;
    Color trendColor = Colors.grey;
    if (movie['trend'] == 'up') {
      trendIcon = Icons.arrow_drop_up_rounded;
      trendColor = Colors.green;
    } else if (movie['trend'] == 'down') {
      trendIcon = Icons.arrow_drop_down_rounded;
      trendColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Số thứ hạng và Xu hướng
          SizedBox(
            width: 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#${movie['rank']}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                Icon(trendIcon, color: trendColor, size: 20),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Ảnh poster nhỏ gọn
          Container(
            width: 36,
            height: 48,
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

          // Tên phim và Thể loại
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['title'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie['genre'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // Số lượng vé bán ra ở góc phải
          Text(
            movie['tickets'],
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}