import '../models/movie_model.dart';
import '../models/category_model.dart';

/// MOCK API SERVICE
/// Giả lập việc gọi API/DB bằng dữ liệu cứng + delay.
/// Sau này khi có backend thật, chỉ cần thay nội dung 2 hàm dưới đây
/// bằng http.get(...), Controller và View không cần sửa gì.
class ApiService {
  // ----- DỮ LIỆU GIẢ (MOCK DATA) -----

  static final List<CategoryModel> _mockCategories = [
    CategoryModel(id: '1', name: 'Hành động'),
    CategoryModel(id: '2', name: 'Hài'),
    CategoryModel(id: '3', name: 'Kinh dị'),
    CategoryModel(id: '4', name: 'Tình cảm'),
    CategoryModel(id: '5', name: 'Hoạt hình'),
  ];

  static final List<Movie> _mockMovies = [
    Movie(
      id: '1',
      title: 'Avengers',
      image: 'https://picsum.photos/seed/avengers/150/220',
      genre: 'Hành động',
      categoryId: '1',
      status: 'now_showing',
      durationMinutes: 142,
      releaseDate: '15/05/2026',
      description: 'Biệt đội siêu anh hùng hợp sức chống lại kẻ thù đe dọa cả vũ trụ.',
    ),
    Movie(
      id: '2',
      title: 'Lật Mặt',
      image: 'https://picsum.photos/seed/latmat/150/220',
      genre: 'Hài',
      categoryId: '2',
      status: 'now_showing',
      durationMinutes: 120,
      releaseDate: '01/06/2026',
      description: 'Câu chuyện hài hước về những tình huống dở khóc dở cười trong gia đình.',
    ),
    Movie(
      id: '3',
      title: 'Conjuring',
      image: 'https://picsum.photos/seed/conjuring/150/220',
      genre: 'Kinh dị',
      categoryId: '3',
      status: 'now_showing',
      durationMinutes: 110,
      releaseDate: '20/05/2026',
      description: 'Bộ phim kinh dị dựa trên hồ sơ điều tra các hiện tượng siêu nhiên.',
    ),
    Movie(
      id: '4',
      title: 'Titanic',
      image: 'https://picsum.photos/seed/titanic/150/220',
      genre: 'Tình cảm',
      categoryId: '4',
      status: 'now_showing',
      durationMinutes: 195,
      releaseDate: '10/06/2026',
      description: 'Câu chuyện tình yêu vượt thời gian trên chuyến tàu định mệnh.',
    ),
    Movie(
      id: '5',
      title: 'Frozen 2',
      image: 'https://picsum.photos/seed/frozen/150/220',
      genre: 'Hoạt hình',
      categoryId: '5',
      status: 'now_showing',
      durationMinutes: 103,
      releaseDate: '05/06/2026',
      description: 'Hành trình khám phá nguồn gốc sức mạnh của Elsa và Anna.',
    ),
    Movie(
      id: '6',
      title: 'Dune 2',
      image: 'https://picsum.photos/seed/dune/150/220',
      genre: 'Hành động',
      categoryId: '1',
      status: 'coming_soon',
      durationMinutes: 166,
      releaseDate: '25/07/2026',
      description: 'Cuộc chiến giành quyền kiểm soát hành tinh sa mạc Arrakis tiếp diễn.',
    ),
    Movie(
      id: '7',
      title: 'Fast X',
      image: 'https://picsum.photos/seed/fastx/150/220',
      genre: 'Hành động',
      categoryId: '1',
      status: 'coming_soon',
      durationMinutes: 141,
      releaseDate: '15/08/2026',
      description: 'Đội đua tốc độ đối mặt với kẻ thù nguy hiểm nhất từ trước đến nay.',
    ),
    Movie(
      id: '8',
      title: 'Annabelle',
      image: 'https://picsum.photos/seed/annabelle/150/220',
      genre: 'Kinh dị',
      categoryId: '3',
      status: 'coming_soon',
      durationMinutes: 99,
      releaseDate: '01/09/2026',
      description: 'Con búp bê bị ám lại tiếp tục gieo rắc nỗi kinh hoàng.',
    ),
  ];


  static final List<BannerItem> _mockBanners = [
    BannerItem(image: 'https://picsum.photos/seed/banner1/400/200', title: 'Avengers: Endgame'),
    BannerItem(image: 'https://picsum.photos/seed/banner2/400/200', title: 'Spider-Man'),
    BannerItem(image: 'https://picsum.photos/seed/banner3/400/200', title: 'Doctor Strange'),
  ];

  // ----- CÁC HÀM "GỌI API" (đang trả mock data) -----

  /// Lấy danh sách thể loại
  static Future<List<CategoryModel>> fetchCategories() async {
    await Future.delayed(const Duration(milliseconds: 400)); // giả lập độ trễ mạng
    return _mockCategories;
  }

  /// Lấy danh sách banner
  static Future<List<BannerItem>> fetchBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBanners;
  }

  /// Lấy danh sách phim, có thể filter theo categoryId
  /// categoryId == null hoặc 'all' -> trả về toàn bộ phim
  static Future<List<Movie>> fetchMovies({String? categoryId}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (categoryId == null || categoryId == 'all') {
      return _mockMovies;
    }
    return _mockMovies.where((m) => m.categoryId == categoryId).toList();
  }
}