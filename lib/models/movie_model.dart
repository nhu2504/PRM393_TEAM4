class Movie {
  final String id;
  final String title;
  final String image;
  final String genre;

  Movie({
    required this.id,
    required this.title,
    required this.image,
    required this.genre,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      genre: json['genre'] ?? '',
    );
  }
}

class BannerItem {
  final String image;
  final String title;

  BannerItem({required this.image, required this.title});
}