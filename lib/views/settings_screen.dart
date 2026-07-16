import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Các biến trạng thái để điều khiển UI của các nút Switch
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  bool _isLocationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Nền xám nhạt đồng bộ với Account
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Cài đặt',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Cài đặt chung'),
            _buildSettingsGroup(
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Thông báo đẩy',
                  value: _isNotificationEnabled,
                  onChanged: (value) => setState(() => _isNotificationEnabled = value),
                ),
                const Divider(height: 1, indent: 56),
                _buildSwitchTile(
                  icon: Icons.location_on_outlined,
                  title: 'Dịch vụ vị trí',
                  value: _isLocationEnabled,
                  onChanged: (value) => setState(() => _isLocationEnabled = value),
                ),
                const Divider(height: 1, indent: 56),
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối (Dark Mode)',
                  value: _isDarkMode,
                  onChanged: (value) => setState(() => _isDarkMode = value),
                ),
                const Divider(height: 1, indent: 56),
                _buildNavigationTile(
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
              children: [
                _buildNavigationTile(
                  icon: Icons.shield_outlined,
                  title: 'Chính sách bảo mật',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildNavigationTile(
                  icon: Icons.description_outlined,
                  title: 'Điều khoản dịch vụ',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildNavigationTile(
                  icon: Icons.help_outline,
                  title: 'Trung tâm trợ giúp',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildNavigationTile(
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

  Widget _buildSettingsGroup({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black..withValues(alpha: 0.03),
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
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showTrailing = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600)) : null,
      trailing: showTrailing ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}