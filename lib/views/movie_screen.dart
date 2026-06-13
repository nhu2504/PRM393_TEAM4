import 'package:flutter/material.dart';
import '../controllers/movie_controller.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/banner_slider_widget.dart';
import 'widgets/category_list_widget.dart';
import 'widgets/section_title_widget.dart';
import 'widgets/movie_list_widget.dart';
import 'search_screen.dart';
import 'movie_detail_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late final MovieController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MovieController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Đặt vé xem phim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading && _controller.categories.length <= 1) {
      // Chỉ hiện loading toàn màn hình ở lần load đầu tiên
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_controller.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _controller.fetchMovieData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _controller.fetchMovieData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ĐOẠN ĐÃ ĐƯỢC SỬA ĐỂ BẤM VÀO LÀ CHUYỂN TRANG ---
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                    settings: const RouteSettings(name: '/search'),
                  ),
                );
              },
              child: AbsorbPointer(
                child: SearchBarWidget(onChanged: (_) {}),
              ),
            ),
            // --------------------------------------------------

            const SizedBox(height: 16),
            BannerSliderWidget(banners: _controller.banners),
            const SizedBox(height: 20),
            CategoryListWidget(
              categories: _controller.categories,
              selectedCategoryId: _controller.selectedCategoryId,
              onSelected: _controller.onCategorySelected,
            ),
            const SizedBox(height: 20),

            // Hiện loading nhỏ khi đang chuyển thể loại
            if (_controller.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              SectionTitleWidget(
                title: 'Phim đang chiếu',
                onSeeAll: _controller.onSeeAllNowShowing,
              ),
              MovieListWidget(
                movies: _controller.nowShowing,
                onTap: _controller.onMovieTap,
              ),
              const SizedBox(height: 20),
              SectionTitleWidget(
                title: 'Phim sắp chiếu',
                onSeeAll: _controller.onSeeAllComingSoon,
              ),
              // --- SỬA ĐOẠN NÀY: CLICK VÀO PHIM ĐANG CHIẾU ĐỂ XEM CHI TIẾT ---
              MovieListWidget(
                movies: _controller.nowShowing,
                onTap: (movie) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovieDetailScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SectionTitleWidget(
                title: 'Phim sắp chiếu',
                onSeeAll: _controller.onSeeAllComingSoon,
              ),
              // --- SỬA ĐOẠN NÀY: CLICK VÀO PHIM SẮP CHIẾU ĐỂ XEM CHI TIẾT ---
              MovieListWidget(
                movies: _controller.comingSoon,
                onTap: (movie) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovieDetailScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}