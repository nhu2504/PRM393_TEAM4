import 'package:flutter/material.dart';
import '../models/cinema_model.dart';
import '../models/room_model.dart';
import '../models/showtime_db_model.dart';
import '../repositories/cinema_repository.dart';

class CinemaDetailController extends ChangeNotifier {
  final CinemaRepository _repository = CinemaRepository();
  CinemaModel? cinema;
  List<RoomModel> rooms = [];
  Map<String, List<ShowtimeDbModel>> roomShowtimes = {}; // roomId -> list of showtimes
  
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCinema(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      cinema = await _repository.getCinemaById(id);
      if (cinema != null) {
        rooms = await _repository.getRoomsByCinemaId(id);
        for (var room in rooms) {
          roomShowtimes[room.id] = await _repository.getShowtimesByRoomId(room.id);
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void setCinema(CinemaModel cinemaModel) async {
    cinema = cinemaModel;
    isLoading = true;
    notifyListeners();
    try {
      rooms = await _repository.getRoomsByCinemaId(cinemaModel.id);
      for (var room in rooms) {
        roomShowtimes[room.id] = await _repository.getShowtimesByRoomId(room.id);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
