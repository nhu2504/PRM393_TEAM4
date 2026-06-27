import 'package:flutter/material.dart';
import '../../models/movie_model.dart';

class BannerSliderWidget extends StatelessWidget {
  final List<BannerItem> banners;

  const BannerSliderWidget({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(banner.image, fit: BoxFit.cover),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        banner.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
