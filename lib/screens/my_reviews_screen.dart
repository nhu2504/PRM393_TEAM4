import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_model.dart';
import '../models/ticket_model.dart';
import '../models/review_model.dart';
import '../controllers/review_controller.dart';
import '../controllers/account_controller.dart';
import 'my_tickets_screen.dart'; // để lấy globalTicketController

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AccountController>().user?.id ?? 'guest';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Lịch sử đánh giá',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.red[600],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red[600],
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Đánh giá Phim'),
              Tab(text: 'Trải nghiệm Rạp'),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: ReviewController.instance,
          builder: (context, _) {
            final ctrl = ReviewController.instance;
            final mine = ctrl.reviewsOfUser(userId);
            final movieReviews = mine
                .where((r) => r.ratingCinema == 0 && r.ratingFood == 0)
                .toList();
            final expReviews = mine
                .where((r) => r.ratingCinema > 0 || r.ratingFood > 0)
                .toList();

            return TabBarView(
              children: [
                _buildList(movieReviews,
                    emptyText: 'Bạn chưa đánh giá phim nào.'),
                _buildList(expReviews,
                    emptyText: 'Bạn chưa đánh giá trải nghiệm rạp nào.',
                    isExperience: true),
              ],
            );
          },
        ),
      ),
    );
  }

  // Tra thông tin phim/rạp từ danh sách vé đã đặt (ReviewModel chỉ có movieId).
  Ticket? _ticketOf(String movieId) {
    for (final t in MyTicketsScreen.globalTicketController.tickets) {
      if (t.movie.id == movieId) return t;
    }
    return null;
  }

  Widget _buildList(List<ReviewModel> reviews,
      {required String emptyText, bool isExperience = false}) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(emptyText, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) =>
          _buildReviewCard(reviews[i], isExperience: isExperience),
    );
  }

  Widget _buildReviewCard(ReviewModel review, {bool isExperience = false}) {
    final ticket = _ticketOf(review.movieId);
    final Movie? movie = ticket?.movie;

    final String title = isExperience
        ? (ticket?.cinemaName ?? 'Rạp chiếu')
        : (movie?.title ?? 'Phim');
    final String imageUrl = movie?.image ?? '';
    final int headline = isExperience
        ? (((review.ratingMovie + review.ratingCinema + review.ratingFood) / 3)
            .round())
        : review.ratingMovie.round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (imageUrl.isEmpty)
                ? _placeholder(isExperience)
                : Image.network(
                    imageUrl,
                    width: isExperience ? 70 : 60,
                    height: isExperience ? 70 : 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(isExperience),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    Text(review.date,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < headline ? Icons.star : Icons.star_border,
                      color: index < headline ? Colors.amber : Colors.grey[300],
                      size: 16,
                    );
                  }),
                ),
                if (isExperience) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Phim ${review.ratingMovie.toStringAsFixed(0)}★  ·  '
                    'Rạp ${review.ratingCinema.toStringAsFixed(0)}★  ·  '
                    'Đồ ăn ${review.ratingFood.toStringAsFixed(0)}★',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                if (review.comment.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    review.comment,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(bool isExperience) => Container(
        width: isExperience ? 70 : 60,
        height: isExperience ? 70 : 90,
        color: Colors.grey[200],
        child: Icon(
          isExperience ? Icons.store_mall_directory : Icons.movie,
          color: Colors.grey,
        ),
      );
}
