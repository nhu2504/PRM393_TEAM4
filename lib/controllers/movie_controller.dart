import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../models/category_model.dart';
import '../repositories/movie_repository.dart';
import '../views/movie_list_screen.dart';
import '../views/movie_detail_screen.dart'; // Import màn hình chi tiết

class MovieController extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  bool isLoading = false;
  String? errorMessage;

  List<BannerItem> banners = [];

  // "Tất cả" luôn có sẵn, id = 'all'
  List<CategoryModel> categories = [
    CategoryModel(id: 'all', name: 'Tất cả'),
  ];
  String selectedCategoryId = 'all';

  List<Movie> nowShowing = [];
  List<Movie> comingSoon = [];

  String searchKeyword = '';

  MovieController() {
    fetchMovieData();
  }

  Future<void> fetchMovieData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 100% lấy từ SQLite qua Repository
      final fetchedBanners = await _repository.getBanners();
      final fetchedCategories = await _repository.getAllCategories();
      final movies = await _repository.getMoviesByCategory(selectedCategoryId);

      banners = fetchedBanners;
      categories = [
        CategoryModel(id: 'all', name: 'Tất cả'),
        ...fetchedCategories,
      ];
      _applyMovies(movies);
    } catch (e) {
      errorMessage = 'Không thể tải dữ liệu từ database: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Gọi khi người dùng chọn thể loại -> lấy từ Repository
  Future<void> onCategorySelected(String categoryId) async {
    if (selectedCategoryId == categoryId) return;

    selectedCategoryId = categoryId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final movies = await _repository.getMoviesByCategory(categoryId);
      _applyMovies(movies);
    } catch (e) {
      errorMessage = 'Không thể tải phim: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Tách phim thành 2 danh sách "đang chiếu" / "sắp chiếu"
  void _applyMovies(List<Movie> movies) {
    nowShowing = movies.where((m) => m.status == 'now_showing').toList();
    comingSoon = movies.where((m) => m.status == 'coming_soon').toList();
  }

  List<Movie> get filteredNowShowing {
    if (searchKeyword.isEmpty) return nowShowing;
    return nowShowing.where((m) => m.title.toLowerCase().contains(searchKeyword.toLowerCase())).toList();
  }

  List<Movie> get filteredComingSoon {
    if (searchKeyword.isEmpty) return comingSoon;
    return comingSoon.where((m) => m.title.toLowerCase().contains(searchKeyword.toLowerCase())).toList();
  }

  void onSearchChanged(String value) {
    searchKeyword = value;
    notifyListeners();
  }

  void onMovieTap(Movie movie) {
    debugPrint('Tapped movie: ${movie.title}');
    // Điều hướng sang trang chi tiết phim
  }

  void onMovieDetailTap(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  void onMovieBookTap(BuildContext context, Movie movie) {
    // Tạm thời điều hướng sang lịch chiếu (hoặc chi tiết rồi chọn lịch)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  void onSeeAllNowShowing(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieListScreen(
          title: 'Phim đang chiếu',
          movies: nowShowing,
          onDetailTap: (movie) => onMovieDetailTap(context, movie),
          onBookTap: (movie) => onMovieBookTap(context, movie),
        ),
      ),
    );
  }

  void onSeeAllComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieListScreen(
          title: 'Phim sắp chiếu',
          movies: comingSoon,
          onDetailTap: (movie) => onMovieDetailTap(context, movie),
          // không truyền onBookTap vì phim sắp chiếu không có nút "Đặt vé"
        ),
      ),
    );
  }
}