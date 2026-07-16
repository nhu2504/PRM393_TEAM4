import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/account_controller.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

class AccountScreen extends StatefulWidget {
  // Nhận userId từ màn hình Đăng nhập truyền sang
  // Tạm thời set mặc định 'u1' để bạn dễ test nếu chưa làm màn Login
  final String userId;

  const AccountScreen({super.key, this.userId = 'u1'});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu từ SQLite ngay khi màn hình vừa được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AccountController>(context, listen: false).fetchUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
            'Hồ sơ cá nhân',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)
        ),
      ),
      body: Consumer<AccountController>(
        builder: (context, controller, child) {
          // 1. Nếu đang load DB thì xoay tròn
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.redAccent));
          }

          // 2. Nếu không tìm thấy User trong DB
          final user = controller.user;
          if (user == null) {
            return _buildEmptyState();
          }

          // 3. Đã có Data -> Vẽ giao diện Profile
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(user),
                const SizedBox(height: 16),
                _buildMenu(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có thông tin người dùng.\nVui lòng đăng nhập lại!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(user) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: user.avatar.isNotEmpty ? NetworkImage(user.avatar) : null,
            child: user.avatar.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
              user.fullName.isEmpty ? 'Người dùng Popcorn' : user.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)
          ),
          const SizedBox(height: 4),
          Text(
              user.email,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600)
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Chỉnh sửa hồ sơ',
            onTap: () {
              // TODO: Chuyển sang màn hình Edit Profile
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildListTile(
            icon: Icons.notifications_none,
            title: 'Thông báo',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildListTile(
            icon: Icons.settings_outlined,
            title: 'Cài đặt',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          _buildListTile(
            icon: Icons.logout,
            title: 'Đăng xuất',
            color: Colors.redAccent,
            onTap: () {
              // TODO: Xử lý đăng xuất
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color ?? Colors.black87
          )
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}