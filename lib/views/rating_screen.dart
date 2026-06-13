import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key}); // Dùng cú pháp mới cho gọn và hết cảnh báo

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _currentRating = 5; // Mặc định chấm 5 sao
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {}, // TODO: Đóng màn hình
        ),
        title: const Text(
          'Đánh giá phim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Ảnh và tên phim
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://picsum.photos/seed/avengers/150/220', // Link ảnh giả lập
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Avengers: Endgame',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Bạn cảm thấy bộ phim này thế nào?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // 2. Thanh chấm sao (Interactive)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    iconSize: 48,
                    icon: Icon(
                      index < _currentRating ? Icons.star : Icons.star_border,
                      color: index < _currentRating ? Colors.amber : Colors.grey[300],
                    ),
                    onPressed: () {
                      setState(() {
                        _currentRating = index + 1; // Cập nhật số sao khi bấm
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Text hiển thị mức độ tương ứng với số sao
              Text(
                _getRatingText(_currentRating),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700]
                ),
              ),
              const SizedBox(height: 32),

              // 3. Ô nhập bình luận
              TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Chia sẻ cảm nhận của bạn về bộ phim...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red[600]!, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 4. Nút Gửi đánh giá
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Gọi Controller gửi dữ liệu đi
                    print('Đã đánh giá: $_currentRating sao');
                    print('Nội dung: ${_commentController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Gửi đánh giá',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm phụ trợ: Đổi số sao thành text hiển thị
  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return 'Rất tệ 😞';
      case 2: return 'Tệ 😕';
      case 3: return 'Bình thường 😐';
      case 4: return 'Hay 🙂';
      case 5: return 'Tuyệt vời! 😍';
      default: return '';
    }
  }
}