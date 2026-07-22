import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Các biến trạng thái để điều khiển UI của các nút Switch
  bool _isNotificationEnabled = true;
  bool _isLocationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Cài đặt chung'),
            _buildSettingsGroup(
              isDark: isDark,
              children: [
                _buildSwitchTile(
                  isDark: isDark,
                  icon: Icons.notifications_active_outlined,
                  title: 'Thông báo đẩy',
                  value: _isNotificationEnabled,
                  onChanged: (value) => setState(() => _isNotificationEnabled = value),
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildSwitchTile(
                  isDark: isDark,
                  icon: Icons.location_on_outlined,
                  title: 'Dịch vụ vị trí',
                  value: _isLocationEnabled,
                  onChanged: (value) => setState(() => _isLocationEnabled = value),
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildSwitchTile(
                  isDark: isDark,
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối (Dark Mode)',
                  value: themeController.isDarkMode,
                  onChanged: (value) => themeController.toggleTheme(),
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildNavigationTile(
                  isDark: isDark,
                  icon: Icons.language,
                  title: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                  onTap: () {
                    // TODO: Hiển thị bottom sheet chọn ngôn ngữ
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('Thông tin & Hỗ trợ'),
            _buildSettingsGroup(
              isDark: isDark,
              children: [
                _buildNavigationTile(
                  isDark: isDark,
                  icon: Icons.shield_outlined,
                  title: 'Chính sách bảo mật',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildNavigationTile(
                  isDark: isDark,
                  icon: Icons.description_outlined,
                  title: 'Điều khoản dịch vụ',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildNavigationTile(
                  isDark: isDark,
                  icon: Icons.help_outline,
                  title: 'Trung tâm trợ giúp',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: isDark ? Colors.grey[800] : Colors.grey[200]),
                _buildNavigationTile(
                  isDark: isDark,
                  icon: Icons.info_outline,
                  title: 'Về PopCornGo',
                  subtitle: 'Phiên bản 1.0.0',
                  showTrailing: false,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({required List<Widget> children, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.redAccent,
        activeColor: Colors.redAccent.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showTrailing = true,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey.shade600)) : null,
      trailing: showTrailing ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
