import 'dart:convert';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movie_json': jsonEncode(movie.toMap()),
      'cinemaName': cinemaName,
      'showDate': showDate,
      'showTime': showTime,
      'seats_json': jsonEncode(seats.map((x) => x.toMap()).toList()),
      'foods_json': jsonEncode(foods),
      'totalAmount': totalAmount,
      'bookingDate': bookingDate,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      movie: Movie.fromJson(jsonDecode(map['movie_json'])),
      cinemaName: map['cinemaName'],
      showDate: map['showDate'],
      showTime: map['showTime'],
      seats: List<Seat>.from(
        jsonDecode(map['seats_json']).map((x) => Seat.fromMap(x)),
      ),
      foods: List<Map<String, dynamic>>.from(jsonDecode(map['foods_json'])),
      totalAmount: map['totalAmount'],
      bookingDate: map['bookingDate'],
    );
  }
}
