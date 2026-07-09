import '../models/movie_model.dart';
import '../models/category_model.dart';
import '../helpers/db_helper.dart';

class MovieRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Movie>> getMoviesByCategory(String categoryId) async {
    return await _dbHelper.getMoviesByCategory(categoryId);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return await _dbHelper.getAllCategories();
  }

  Future<List<Movie>> getMoviesByStatus(String status) async {
    return await _dbHelper.getMoviesByStatus(status);
  }

  Future<List<BannerItem>> getBanners() async {
    return await _dbHelper.getAllBanners();
  }
}
