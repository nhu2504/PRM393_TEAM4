import 'package:flutter/material.dart';
import '../controllers/movie_controller.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/banner_slider_widget.dart';
import 'widgets/category_list_widget.dart';
import 'widgets/section_title_widget.dart';
import 'widgets/movie_list_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _movieScreenState();
}

class _movieScreenState extends State<MovieScreen> {
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
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _controller.fetchMovieData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWidget(onChanged: _controller.onSearchChanged),
              const SizedBox(height: 16),
              BannerSliderWidget(banners: _controller.banners),
              const SizedBox(height: 20),
              CategoryListWidget(categories: _controller.categories),
              const SizedBox(height: 20),
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
              MovieListWidget(
                movies: _controller.comingSoon,
                onTap: _controller.onMovieTap,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}