import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../models/review_model.dart';
import '../controllers/review_controller.dart';
import '../controllers/account_controller.dart';

class RatingScreen extends StatefulWidget {
  /// Phim cần đánh giá — truyền từ 1 vé (ticket.movie) hoặc màn chi tiết phim.
  final Movie movie;

  const RatingScreen({super.key, required this.movie});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _currentRating = 5;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _today() {
    final n = DateTime.now();
    return '${n.day.toString().padLeft(2, '0')}/'
        '${n.month.toString().padLeft(2, '0')}/${n.year}';
  }

  Future<void> _submit() async {
    final userId = context.read<AccountController>().user?.id ?? 'guest';

    final review = ReviewModel(
      id: 'REV_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      movieId: widget.movie.id,
      ratingMovie: _currentRating.toDouble(),
      ratingCinema: 0,
      ratingFood: 0,
      comment: _commentController.text.trim(),
      date: _today(),
    );

    await ReviewController.instance.addReview(review);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi đánh giá phim!')),
    );
    Navigator.pop(context, review);
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
          onPressed: () => Navigator.pop(context),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.movie.image,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 180,
                    color: Colors.grey[200],
                    child: const Icon(Icons.movie, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.movie.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Bạn cảm thấy bộ phim này thế nào?',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    iconSize: 48,
                    icon: Icon(
                      index < _currentRating ? Icons.star : Icons.star_border,
                      color: index < _currentRating ? Colors.amber : Colors.grey[300],
                    ),
                    onPressed: () => setState(() => _currentRating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                _getRatingText(_currentRating),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
              const SizedBox(height: 32),

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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
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
