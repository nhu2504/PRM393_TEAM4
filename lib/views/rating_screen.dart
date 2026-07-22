import 'package:flutter/material.dart';
import '../controllers/rating_controller.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final RatingController _controller = RatingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    _controller.updateComment(_commentController.text);
    bool success = await _controller.submitRating('movie_123'); // Giả lập ID phim

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cảm ơn bạn đã đánh giá!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Quay lại sau khi gửi thành công
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể gửi đánh giá, vui lòng thử lại!')),
      );
    }
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
          onPressed: () {
            Navigator.pop(context);
          },
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
                  'https://picsum.photos/seed/avengers/150/220',
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

              // 2. Thanh chấm sao
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    iconSize: 48,
                    icon: Icon(
                      index < _controller.currentStar ? Icons.star : Icons.star_border,
                      color: index < _controller.currentStar ? Colors.amber : Colors.grey[300],
                    ),
                    onPressed: _controller.isSubmitting
                        ? null
                        : () => _controller.updateStar(index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),

              Text(
                _getRatingText(_controller.currentStar),
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
                enabled: !_controller.isSubmitting,
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
                  onPressed: _controller.isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _controller.isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
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