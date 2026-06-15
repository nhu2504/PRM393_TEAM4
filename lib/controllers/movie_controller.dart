import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../views/movie_list_screen.dart';
class MovieController extends ChangeNotifier {
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

  /// Load toàn bộ dữ liệu ban đầu: banner, thể loại, phim
  Future<void> fetchMovieData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final fetchedBanners = await ApiService.fetchBanners();
      final fetchedCategories = await ApiService.fetchCategories();
      final movies = await ApiService.fetchMovies(categoryId: selectedCategoryId);

      banners = fetchedBanners;
      categories = [
        CategoryModel(id: 'all', name: 'Tất cả'),
        ...fetchedCategories,
      ];
      _applyMovies(movies);
    } catch (e) {
      errorMessage = 'Không thể tải dữ liệu: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Gọi khi người dùng chọn thể loại -> gọi lại API lấy phim theo thể loại
  Future<void> onCategorySelected(String categoryId) async {
    if (selectedCategoryId == categoryId) return;

    selectedCategoryId = categoryId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final movies = await ApiService.fetchMovies(categoryId: categoryId);
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

  void onSearchChanged(String value) {
    searchKeyword = value;
    notifyListeners();
  }

  void onMovieTap(Movie movie) {
    debugPrint('Tapped movie: ${movie.title}');
    // TODO: điều hướng sang trang chi tiết phim (nếu cần)
  }

  void onMovieDetailTap(BuildContext context, Movie movie) {
    // TODO: điều hướng sang trang chi tiết phim
    debugPrint('Xem chi tiết: ${movie.title}');
  }

  void onMovieBookTap(BuildContext context, Movie movie) {
    // TODO: điều hướng sang trang đặt vé
    debugPrint('Đặt vé: ${movie.title}');
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