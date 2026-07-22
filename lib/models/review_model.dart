// lib/models/review_model.dart

class ReviewModel {
  final String reviewId; // Mã đánh giá
  final String userId; // ID người dùng đang đánh giá
  final String movieId; // Phim được đánh giá
  final int rating; // Số sao (1 đến 5)
  final String comment; // Nội dung bình luận
  final DateTime createdAt; // Thời gian gửi đánh giá

  ReviewModel({
    required this.reviewId,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'] ?? '',
      userId: json['userId'] ?? '',
      movieId: json['movieId'] ?? '',
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'movieId': movieId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}