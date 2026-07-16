import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/user_model.dart';


class AccountController extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true; // Trạng thái loading khi đang chọc DB

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners(); // Báo cho UI hiện vòng xoay loading

    try {
      _user = await DatabaseHelper.instance.getUserById(userId);
    } catch (e) {
      debugPrint("Lỗi khi lấy thông tin user: $e");
    }

    _isLoading = false;
    notifyListeners(); // Báo cho UI tắt loading, vẽ giao diện mới
  }

  Future<void> updateUser(UserModel updatedUser) async {
    await DatabaseHelper.instance.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners(); // Báo cho UI cập nhật ngay lập tức
  }
}