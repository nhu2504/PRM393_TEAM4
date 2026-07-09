class ReviewModel {
  final String id;
  final String userId;
  final String movieId;
  final double ratingMovie;
  final double ratingCinema;
  final double ratingFood;
  final String comment;
  final String imagePath;
  final String date;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.ratingMovie,
    required this.ratingCinema,
    required this.ratingFood,
    required this.comment,
    this.imagePath = '',
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'movieId': movieId,
      'ratingMovie': ratingMovie,
      'ratingCinema': ratingCinema,
      'ratingFood': ratingFood,
      'comment': comment,
      'imagePath': imagePath,
      'date': date,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      movieId: map['movieId']?.toString() ?? '',
      ratingMovie: (map['ratingMovie'] as num?)?.toDouble() ?? 0.0,
      ratingCinema: (map['ratingCinema'] as num?)?.toDouble() ?? 0.0,
      ratingFood: (map['ratingFood'] as num?)?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
      imagePath: map['imagePath'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
