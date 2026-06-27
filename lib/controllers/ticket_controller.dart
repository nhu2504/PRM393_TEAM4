import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../helpers/db_helper.dart';

/// Controller toàn cục để quản lý danh sách vé đã đặt.
/// Được khởi tạo 1 lần ở main.dart và truyền xuống các màn hình cần dùng.
class TicketController extends ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => List.unmodifiable(_tickets);

  Future<void> fetchTickets() async {
    _tickets = await DatabaseHelper.instance.getAllTickets();
    notifyListeners();
  }

  /// Thêm vé mới sau khi thanh toán thành công
  Future<void> addTicket(Ticket ticket) async {
    await DatabaseHelper.instance.insertTicket(ticket);
    _tickets.insert(0, ticket); // Vé mới nhất lên đầu
    notifyListeners();
  }

  /// Lọc vé sắp chiếu (showDate >= hôm nay hoặc không parse được ngày)
  List<Ticket> get upcomingTickets {
    final now = DateTime.now();
    return _tickets.where((t) {
      final date = _parseDate(t.showDate);
      // Nếu date null (dữ liệu mock không đúng chuẩn dd/MM/yyyy) -> mặc định cho vào sắp chiếu
      if (date == null) return true;
      return date.isAfter(now) || _isSameDay(date, now);
    }).toList();
  }

  /// Lọc vé đã xem (showDate < hôm nay)
  List<Ticket> get pastTickets {
    final now = DateTime.now();
    return _tickets.where((t) {
      final date = _parseDate(t.showDate);
      return date != null && date.isBefore(now) && !_isSameDay(date, now);
    }).toList();
  }

  /// Hủy vé
  Future<void> cancelTicket(String ticketId) async {
    await DatabaseHelper.instance.deleteTicket(ticketId);
    _tickets.removeWhere((t) => t.id == ticketId);
    notifyListeners();
  }

  /// Parse ngày dạng "dd/MM/yyyy" thành DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (_) {}
    return null;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Tạo mock data ban đầu (tùy chọn)
  void loadMockData() {
    // Nếu muốn có dữ liệu ban đầu, gọi hàm này ở main
    // Hiện tại để trống, vé sẽ được thêm khi user thực sự đặt vé
  }
}
