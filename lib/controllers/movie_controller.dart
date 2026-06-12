import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieController extends ChangeNotifier {
  bool isLoading = false;

  List<BannerItem> banners = [];
  List<String> categories = [];
  List<Movie> nowShowing = [];
  List<Movie> comingSoon = [];

  String searchKeyword = '';

  MovieController() {
    fetchMovieData();
  }

  Future<void> fetchMovieData() async {
    isLoading = true;
    notifyListeners();

    // TODO: Thay bằng gọi API thực tế
    await Future.delayed(const Duration(milliseconds: 500));

    banners = [
      BannerItem(image: 'https://via.placeholder.com/400x200', title: 'Avengers: Endgame'),
      BannerItem(image: 'https://via.placeholder.com/400x200', title: 'Spider-Man'),
      BannerItem(image: 'https://via.placeholder.com/400x200', title: 'Doctor Strange'),
    ];

    categories = ['Hành động', 'Hài', 'Kinh dị', 'Tình cảm', 'Hoạt hình'];

    nowShowing = [
      Movie(id: '1', image: 'https://via.placeholder.com/150x220', title: 'Avengers', genre: 'Hành động'),
      Movie(id: '2', image: 'https://via.placeholder.com/150x220', title: 'Joker', genre: 'Tâm lý'),
      Movie(id: '3', image: 'https://via.placeholder.com/150x220', title: 'Frozen 2', genre: 'Hoạt hình'),
    ];

    comingSoon = [
      Movie(id: '4', image: 'https://via.placeholder.com/150x220', title: 'Dune 2', genre: 'Khoa học viễn tưởng'),
      Movie(id: '5', image: 'https://via.placeholder.com/150x220', title: 'Fast X', genre: 'Hành động'),
    ];

    isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String value) {
    searchKeyword = value;
    notifyListeners();
    // TODO: gọi API tìm kiếm hoặc filter danh sách phim
  }

  void onMovieTap(Movie movie) {
    // TODO: điều hướng sang màn hình chi tiết phim
    debugPrint('Tapped movie: ${movie.title}');
  }

  void onSeeAllNowShowing() {
    // TODO: điều hướng sang danh sách đầy đủ "Phim đang chiếu"
  }

  void onSeeAllComingSoon() {
    // TODO: điều hướng sang danh sách đầy đủ "Phim sắp chiếu"
  }
}