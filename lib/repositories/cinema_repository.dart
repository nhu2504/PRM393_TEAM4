import '../models/cinema_model.dart';
import '../models/room_model.dart';
import '../models/showtime_db_model.dart';
import '../helpers/db_helper.dart';

class CinemaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<CinemaModel>> getAllCinemas({String? city, String? brand}) async {
    return await _dbHelper.getAllCinemas(city: city, brand: brand);
  }

  Future<List<String>> getCinemaBrands() async {
    return await _dbHelper.getCinemaBrands();
  }

  Future<CinemaModel?> getCinemaById(String id) async {
    return await _dbHelper.getCinemaById(id);
  }

  Future<List<RoomModel>> getRoomsByCinemaId(String cinemaId) async {
    return await _dbHelper.getRoomsByCinemaId(cinemaId);
  }

  Future<List<ShowtimeDbModel>> getShowtimesByRoomId(String roomId) async {
    return await _dbHelper.getShowtimesByRoomId(roomId);
  }
}
