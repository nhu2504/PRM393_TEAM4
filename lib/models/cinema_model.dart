class CinemaModel {
  final String id;
  final String name;
  final String address;
  final String image;
  final String city;
  final String brand; // CGV, Lotte, BHD, Galaxy...
  final double latitude;
  final double longitude;

  CinemaModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.city,
    required this.brand,
    required this.latitude,
    required this.longitude,
  });

  factory CinemaModel.fromJson(Map<String, dynamic> json) {
    return CinemaModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      city: json['city'] ?? '',
      brand: json['brand'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'image': image,
      'city': city,
      'brand': brand,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// Lịch chiếu của 1 phim tại 1 rạp
class ShowtimeModel {
  final String movieId;
  final String movieTitle;
  final String movieImage;
  final List<String> times;

  ShowtimeModel({
    required this.movieId,
    required this.movieTitle,
    required this.movieImage,
    required this.times,
  });
}