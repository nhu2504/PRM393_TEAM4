import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../helpers/db_helper.dart';

/// Quản lý toàn bộ đánh giá (ReviewModel).
///
/// Dùng singleton [instance] để mọi màn hình chia sẻ chung 1 nguồn dữ liệu,
/// giống hệt cách bạn đang dùng `MyTicketsScreen.globalTicketController`.
///
/// Cách phân loại (ReviewModel không có cột `type`):
///  - Đánh giá phim      : chỉ có ratingMovie, còn ratingCinema == 0 && ratingFood == 0.
///  - Đánh giá trải nghiệm: có ratingCinema > 0 hoặc ratingFood > 0.
class ReviewController extends ChangeNotifier {
  ReviewController._();
  static final ReviewController instance = ReviewController._();

  List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  List<ReviewModel> get movieReviews =>
      _reviews.where((r) => r.ratingCinema == 0 && r.ratingFood == 0).toList();

  List<ReviewModel> get experienceReviews =>
      _reviews.where((r) => r.ratingCinema > 0 || r.ratingFood > 0).toList();

  /// Chỉ lấy đánh giá của 1 user (dùng cho màn Lịch sử).
  List<ReviewModel> reviewsOfUser(String userId) =>
      _reviews.where((r) => r.userId == userId).toList();

  /// Nạp dữ liệu từ DB — gọi trong main() giống fetchTickets().
  Future<void> fetchReviews() async {
    try {
      _reviews = await DatabaseHelper.instance.getAllReviews();
    } catch (e) {
      debugPrint('Lỗi tải reviews: $e');
    }
    notifyListeners();
  }

  /// Thêm đánh giá: lưu DB rồi cập nhật list ngay cho UI.
  Future<void> addReview(ReviewModel review) async {
    try {
      await DatabaseHelper.instance.insertReview(review);
    } catch (e) {
      debugPrint('Lỗi lưu review: $e');
    }
    _reviews.insert(0, review);
    notifyListeners();
  }

  Future<void> deleteReview(String id) async {
    try {
      await DatabaseHelper.instance.deleteReview(id);
    } catch (e) {
      debugPrint('Lỗi xoá review: $e');
    }
    _reviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
