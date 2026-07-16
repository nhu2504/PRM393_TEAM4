import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Dữ liệu mẫu (Mock data) cho thông báo
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'Đặt vé thành công!',
      'message': 'Vé xem phim Avengers: Endgame của bạn đã được xác nhận. Vui lòng kiểm tra mục "Vé của tôi".',
      'time': '10:30 AM',
      'isRead': false,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'title': 'Khuyến mãi đặc biệt 🎉',
      'message': 'Giảm ngay 20% cho Combo Bắp Nước khi nhập mã POPCORN20. Nhanh tay kẻo lỡ!',
      'time': 'Hôm qua',
      'isRead': false,
      'icon': Icons.local_offer,
      'color': Colors.redAccent,
    },
    {
      'title': 'Phim sắp chiếu',
      'message': 'Phim "Lật Mặt 7" bạn quan tâm sẽ chính thức khởi chiếu vào ngày mai.',
      'time': '20/05/2026',
      'isRead': true,
      'icon': Icons.movie,
      'color': Colors.blue,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Đánh dấu đã đọc tất cả',
            icon: const Icon(Icons.done_all, color: Colors.blue),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('Không có thông báo nào.'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              // Đổi màu nền nếu chưa đọc
              color: notif['isRead'] ? Colors.white : Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notif['isRead'] ? Colors.grey.shade200 : Colors.blue.shade200,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: notif['color'].withOpacity(0.1),
                child: Icon(notif['icon'], color: notif['color']),
              ),
              title: Text(
                notif['title'],
                style: TextStyle(
                  fontWeight: notif['isRead'] ? FontWeight.normal : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['message'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notif['time'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Khi bấm vào thì chuyển sang trạng thái đã đọc
                setState(() {
                  notif['isRead'] = true;
                });
              },
            ),
          );
        },
      ),
    );
  }
}