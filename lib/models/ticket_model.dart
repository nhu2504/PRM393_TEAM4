import 'seat_model.dart';
import 'movie_model.dart';

class Ticket {
  final String id;
  final Movie movie;
  final String cinemaName;
  final String showDate;
  final String showTime;
  final List<Seat> seats;
  final List<Map<String, dynamic>> foods; // {'name': '...', 'price': ..., 'qty': ...}
  final int totalAmount;
  final String bookingDate;

  Ticket({
    required this.id,
    required this.movie,
    required this.cinemaName,
    required this.showDate,
    required this.showTime,
    required this.seats,
    required this.foods,
    required this.totalAmount,
    required this.bookingDate,
  });
}
