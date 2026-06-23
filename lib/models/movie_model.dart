class Movie {
  final String id;
  final String title;
  final String image;
  final String genre;
  final String categoryId;
  final String status; // 'now_showing' hoặc 'coming_soon'
  final int durationMinutes; // thời lượng phim (phút)
  final String releaseDate; // ngày khởi chiếu, dạng "dd/MM/yyyy"
  final String description; // mô tả ngắn / thông tin phim

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.genre,
    required this.categoryId,
    required this.status,
    required this.durationMinutes,
    required this.releaseDate,
    this.description = '',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      genre: json['genre'] ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      status: json['status'] ?? 'now_showing',
      durationMinutes: json['durationMinutes'] ?? 0,
      releaseDate: json['releaseDate'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class BannerItem {
  final String image;
  final String title;

  BannerItem({required this.image, required this.title});
}