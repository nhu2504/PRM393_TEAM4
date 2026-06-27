import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieListScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final ValueChanged<Movie>? onDetailTap;
  final ValueChanged<Movie>? onBookTap;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.movies,
    this.onDetailTap,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: movies.isEmpty
          ? const Center(
        child: Text('Không có phim nào', style: TextStyle(color: Colors.grey)),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _MovieListItem(
            movie: movie,
            onDetailTap: () => onDetailTap?.call(movie),
            onBookTap: () => onBookTap?.call(movie),
          );
        },
      ),
    );
  }
}

class _MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onDetailTap;
  final VoidCallback onBookTap;

  const _MovieListItem({
    required this.movie,
    required this.onDetailTap,
    required this.onBookTap,
  });

  bool get isNowShowing => movie.status == 'now_showing';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phim bên trái
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              movie.image,
              width: 100,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Thể loại
                Text(
                  movie.genre,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 6),

                // Thời lượng
                _InfoRow(
                  icon: Icons.access_time,
                  text: '${movie.durationMinutes} phút',
                ),
                const SizedBox(height: 4),

                // Ngày khởi chiếu
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: movie.releaseDate,
                ),
                const SizedBox(height: 6),

                // Mô tả ngắn
                if (movie.description.isNotEmpty)
                  Text(
                    movie.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),

                const SizedBox(height: 10),

                // Nút hành động
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDetailTap,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Xem chi tiết',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ),
                    if (isNowShowing) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onBookTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Đặt vé',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget nhỏ hiển thị 1 dòng icon + text (dùng cho thời lượng, ngày khởi chiếu)
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}
