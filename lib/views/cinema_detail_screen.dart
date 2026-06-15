import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cinema_model.dart';

class CinemaDetailScreen extends StatelessWidget {
  final CinemaModel cinema;

  const CinemaDetailScreen({super.key, required this.cinema});

  /// Ảnh bản đồ tĩnh chụp đúng vị trí rạp (Mapbox Static Images API).
  /// Token dùng ở đây là token demo công khai của Mapbox, chỉ phù hợp cho
  /// dev/test. Khi triển khai thật, nên đăng ký token riêng tại mapbox.com
  /// (free tier khá rộng rãi) và thay vào biến _mapboxAccessToken.
  static const String _mapboxAccessToken =
      'TOKEN';

  String get _staticMapImage {
    final lng = cinema.longitude;
    final lat = cinema.latitude;
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
        'pin-l+ff0000($lng,$lat)/'
        '$lng,$lat,15,0/'
        '600x300@2x'
        '?access_token=$_mapboxAccessToken';
  }

  Future<void> _openGoogleMaps() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${cinema.latitude},${cinema.longitude}',
    );
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      debugPrint('launched Google Maps: $launched');
    } catch (e) {
      debugPrint('Lỗi mở Google Maps: $e');
    }
  }

  Future<void> _openAppleMaps() async {
    final uri = Uri.parse(
      'https://maps.apple.com/?ll=${cinema.latitude},${cinema.longitude}&q=${Uri.encodeComponent(cinema.name)}',
    );
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      debugPrint('launched Apple Maps: $launched');
    } catch (e) {
      debugPrint('Lỗi mở Apple Maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          cinema.name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bản đồ vị trí
            Stack(
              children: [
                Image.network(
                  _staticMapImage,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey[300],
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                          Positioned(
                            bottom: 16,
                            child: Text(
                              '${cinema.latitude.toStringAsFixed(4)}, ${cinema.longitude.toStringAsFixed(4)}',
                              style: TextStyle(color: Colors.grey[700], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),

                // 2 nút mở Google Maps / Apple Maps
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Row(
                    children: [
                      _MapButton(
                        icon: Icons.map,
                        label: 'Google Maps',
                        color: Colors.blue,
                        onTap: _openGoogleMaps,
                      ),
                      const SizedBox(width: 8),
                      _MapButton(
                        icon: Icons.location_on,
                        label: 'Apple Maps',
                        color: Colors.grey[800]!,
                        onTap: _openAppleMaps,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Thông tin rạp
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          cinema.brand,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(cinema.city, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cinema.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          cinema.address,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút tròn nhỏ nổi trên bản đồ để mở app bản đồ bên ngoài
class _MapButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MapButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}