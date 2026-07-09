import 'package:flutter/material.dart';
import '../models/cinema_model.dart';
import '../repositories/cinema_repository.dart';

class CinemaController extends ChangeNotifier {
  final CinemaRepository _repository = CinemaRepository();
  bool isLoading = false;
  String? errorMessage;

  List<String> cities = ['Tất cả', 'Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng'];
  String selectedCity = 'Tất cả';

  List<String> brands = ['Tất cả'];
  String selectedBrand = 'Tất cả';

  List<CinemaModel> cinemas = [];

  CinemaController() {
    _init();
  }

  Future<void> _init() async {
    final fetchedBrands = await _repository.getCinemaBrands();
    brands = ['Tất cả', ...fetchedBrands];
    await fetchCinemas();
  }

  Future<void> fetchCinemas() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      cinemas = await _repository.getAllCinemas(
        city: selectedCity == 'Tất cả' ? null : selectedCity,
        brand: selectedBrand == 'Tất cả' ? null : selectedBrand,
      );
    } catch (e) {
      errorMessage = 'Không thể tải danh sách rạp: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> onCitySelected(String city) async {
    if (selectedCity == city) return;
    selectedCity = city;
    await fetchCinemas();
  }

  Future<void> onBrandSelected(String brand) async {
    if (selectedBrand == brand) return;
    selectedBrand = brand;
    await fetchCinemas();
  }

  /// Nhóm danh sách rạp theo thành phố (chỉ dùng khi selectedCity == 'Tất cả')
  Map<String, List<CinemaModel>> get cinemasGroupedByCity {
    final Map<String, List<CinemaModel>> grouped = {};
    for (final cinema in cinemas) {
      grouped.putIfAbsent(cinema.city, () => []).add(cinema);
    }
    return grouped;
  }
}