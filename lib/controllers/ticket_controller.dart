import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../helpers/db_helper.dart';

class TicketController extends ChangeNotifier {
  List<Ticket> _tickets = [];

  List<Ticket> get tickets => List.unmodifiable(_tickets);

  Future<void> fetchTickets() async {
    _tickets = await DatabaseHelper.instance.getAllTickets();
    notifyListeners();
  }

  Future<void> addTicket(Ticket ticket) async {
    await DatabaseHelper.instance.insertTicket(ticket);
    _tickets.insert(0, ticket);
    notifyListeners();
  }

  List<Ticket> get upcomingTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      final date = _parseDate(ticket.showDate);
      if (date == null) return true;
      if (date.isAfter(now)) return true;
      if (_isSameDay(date, now)) {
        final showDateTime = _buildShowDateTime(date, ticket.showTime);
        if (showDateTime == null) return true;
        return !showDateTime.isBefore(now);
      }
      return false;
    }).toList();
  }

  List<Ticket> get pastTickets {
    final now = DateTime.now();
    return _tickets.where((ticket) {
      final date = _parseDate(ticket.showDate);
      if (date == null) return false;
      if (date.isBefore(now) && !_isSameDay(date, now)) return true;
      if (_isSameDay(date, now)) {
        final showDateTime = _buildShowDateTime(date, ticket.showTime);
        if (showDateTime == null) return false;
        return showDateTime.isBefore(now);
      }
      return false;
    }).toList();
  }

  Future<void> cancelTicket(String ticketId) async {
    await DatabaseHelper.instance.deleteTicket(ticketId);
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
    notifyListeners();
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}
    return null;
  }

  DateTime? _buildShowDateTime(DateTime date, String showTime) {
    try {
      final parts = showTime.split(':');
      if (parts.length == 2) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void loadMockData() {
    // Intentionally empty.
  }
}
