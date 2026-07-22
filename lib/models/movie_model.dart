class Movie {
  final String id;
  final String title;
  final String image;
  final String genre;
  final String categoryId;
  final String status; // 'now_showing' hoặc 'coming_soon'

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.genre,
    required this.categoryId,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      genre: json['genre'] ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      status: json['status'] ?? 'now_showing',
    );
  }
}

class BannerItem {
  final String image;
  final String title;

  BannerItem({required this.image, required this.title});
}