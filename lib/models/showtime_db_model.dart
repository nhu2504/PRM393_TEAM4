class ShowtimeDbModel {
  final String id;
  final String movieId;
  final String roomId;
  final String date; // dd/MM/yyyy
  final String time; // HH:mm

  ShowtimeDbModel({
    required this.id,
    required this.movieId,
    required this.roomId,
    required this.date,
    required this.time,
  });

  factory ShowtimeDbModel.fromMap(Map<String, dynamic> map) {
    return ShowtimeDbModel(
      id: map['id'].toString(),
      movieId: map['movieId'].toString(),
      roomId: map['roomId'].toString(),
      date: map['date'] ?? '',
      time: map['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'roomId': roomId,
      'date': date,
      'time': time,
    };
  }
}
