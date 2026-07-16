import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ticket_model.dart';
import '../models/user_model.dart';
import '../models/review_model.dart';
import '../models/movie_model.dart';
import '../models/cinema_model.dart';
import '../models/category_model.dart';
import '../models/room_model.dart';
import '../models/showtime_db_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('popcorngo_v7.db');
    await _checkAndSeed(_database!);
    return _database!;
  }

  Future<void> _checkAndSeed(Database db) async {
    final movieCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM movies'));
    if (movieCount == 0) {
      await _seedData(db);
    }

    final bannerCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM banners'));
    if (bannerCount == 0) {
      await _seedBanners(db);
    }

    final roomCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM rooms'));
    if (roomCount == 0) {
      await _seedExtraData(db);
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _seedBanners(Database db) async {
    final banners = [
      {
        'image': 'https://picsum.photos/seed/banner1/400/200',
        'title': 'Avengers: Endgame'
      },
      {
        'image': 'https://picsum.photos/seed/banner2/400/200',
        'title': 'Spider-Man'
      },
      {
        'image': 'https://picsum.photos/seed/banner3/400/200',
        'title': 'Doctor Strange'
      },
    ];
    for (var banner in banners) {
      await db.insert('banners', banner);
    }
  }

  Future<void> _seedData(Database db) async {
    // Seed Categories từ ApiService
    final categories = [
      {'id': '1', 'name': 'Hành động'},
      {'id': '2', 'name': 'Hài'},
      {'id': '3', 'name': 'Kinh dị'},
      {'id': '4', 'name': 'Tình cảm'},
      {'id': '5', 'name': 'Hoạt hình'},
    ];
    for (var cat in categories) {
      await db.insert('categories', cat);
    }

    // Seed Movies từ ApiService
    final movies = [
      {
        'id': '1',
        'title': 'Avengers',
        'image': 'https://picsum.photos/seed/avengers/150/220',
        'genre': 'Hành động',
        'categoryId': '1',
        'status': 'now_showing',
        'durationMinutes': 142,
        'releaseDate': '15/05/2026',
        'description': 'Biệt đội siêu anh hùng hợp sức chống lại kẻ thù đe dọa cả vũ trụ.',
        'rating': 4.8
      },
      {
        'id': '2',
        'title': 'Lật Mặt',
        'image': 'https://picsum.photos/seed/latmat/150/220',
        'genre': 'Hài',
        'categoryId': '2',
        'status': 'now_showing',
        'durationMinutes': 120,
        'releaseDate': '01/06/2026',
        'description': 'Câu chuyện hài hước về những tình huống dở khóc dở cười trong gia đình.',
        'rating': 4.5
      },
      {
        'id': '3',
        'title': 'Conjuring',
        'image': 'https://picsum.photos/seed/conjuring/150/220',
        'genre': 'Kinh dị',
        'categoryId': '3',
        'status': 'now_showing',
        'durationMinutes': 110,
        'releaseDate': '20/05/2026',
        'description': 'Bộ phim kinh dị dựa trên hồ sơ điều tra các hiện tượng siêu nhiên.',
        'rating': 4.3
      },
      {
        'id': '4',
        'title': 'Titanic',
        'image': 'https://picsum.photos/seed/titanic/150/220',
        'genre': 'Tình cảm',
        'categoryId': '4',
        'status': 'now_showing',
        'durationMinutes': 195,
        'releaseDate': '10/06/2026',
        'description': 'Câu chuyện tình yêu vượt thời gian trên chuyến tàu định mệnh.',
        'rating': 4.9
      },
      {
        'id': '5',
        'title': 'Frozen 2',
        'image': 'https://picsum.photos/seed/frozen/150/220',
        'genre': 'Hoạt hình',
        'categoryId': '5',
        'status': 'now_showing',
        'durationMinutes': 103,
        'releaseDate': '05/06/2026',
        'description': 'Hành trình khám phá nguồn gốc sức mạnh của Elsa và Anna.',
        'rating': 4.7
      },
      {
        'id': '6',
        'title': 'Dune 2',
        'image': 'https://picsum.photos/seed/dune/150/220',
        'genre': 'Hành động',
        'categoryId': '1',
        'status': 'coming_soon',
        'durationMinutes': 166,
        'releaseDate': '25/07/2026',
        'description': 'Cuộc chiến giành quyền kiểm soát hành tinh sa mạc Arrakis tiếp diễn.',
        'rating': 4.6
      },
      {
        'id': '7',
        'title': 'Fast X',
        'image': 'https://picsum.photos/seed/fastx/150/220',
        'genre': 'Hành động',
        'categoryId': '1',
        'status': 'coming_soon',
        'durationMinutes': 141,
        'releaseDate': '15/08/2026',
        'description': 'Đội đua tốc độ đối mặt với kẻ thù nguy hiểm nhất từ trước đến nay.',
        'rating': 4.4
      },
      {
        'id': '8',
        'title': 'Annabelle',
        'image': 'https://picsum.photos/seed/annabelle/150/220',
        'genre': 'Kinh dị',
        'categoryId': '3',
        'status': 'coming_soon',
        'durationMinutes': 99,
        'releaseDate': '01/09/2026',
        'description': 'Con búp bê bị ám lại tiếp tục gieo rắc nỗi kinh hoàng.',
        'rating': 4.2
      },
    ];
    for (var movie in movies) {
      await db.insert('movies', movie);
    }

    // Seed Cinemas từ ApiService
    final cinemas = [
      {
        'id': '1',
        'name': 'CGV Vincom Bà Triệu',
        'address': '191 Bà Triệu, Hai Bà Trưng, Hà Nội',
        'image': 'https://picsum.photos/seed/cinema1/300/200',
        'city': 'Hà Nội',
        'brand': 'CGV',
        'latitude': 21.0095,
        'longitude': 105.8470,
        'phone': '1900 6017'
      },
      {
        'id': '2',
        'name': 'Lotte Cinema Landmark 81',
        'address': '720A Điện Biên Phủ, Bình Thạnh, TP.HCM',
        'image': 'https://picsum.photos/seed/cinema2/300/200',
        'city': 'TP. Hồ Chí Minh',
        'brand': 'Lotte Cinema',
        'latitude': 10.7951,
        'longitude': 106.7218,
        'phone': '028 3822 0333'
      },
      {
        'id': '3',
        'name': 'BHD Star Phạm Ngọc Thạch',
        'address': '6 Phạm Ngọc Thạch, Đống Đa, Hà Nội',
        'image': 'https://picsum.photos/seed/cinema3/300/200',
        'city': 'Hà Nội',
        'brand': 'BHD Star',
        'latitude': 21.0124,
        'longitude': 105.8252,
        'phone': '1900 2099'
      },
      {
        'id': '4',
        'name': 'Galaxy Nguyễn Du',
        'address': '116 Nguyễn Du, Quận 1, TP.HCM',
        'image': 'https://picsum.photos/seed/cinema4/300/200',
        'city': 'TP. Hồ Chí Minh',
        'brand': 'Galaxy Cinema',
        'latitude': 10.7762,
        'longitude': 106.6917,
        'phone': '1900 2224'
      },
      {
        'id': '5',
        'name': 'CGV Vĩnh Trung Plaza',
        'address': '255-257 Hùng Vương, Thanh Khê, Đà Nẵng',
        'image': 'https://picsum.photos/seed/cinema5/300/200',
        'city': 'Đà Nẵng',
        'brand': 'CGV',
        'latitude': 16.0678,
        'longitude': 108.2099,
        'phone': '1900 6017'
      },
    ];
    for (var cinema in cinemas) {
      await db.insert('cinemas', cinema);
    }
  }

  Future<void> _seedExtraData(Database db) async {
    // Seed Rooms cho các rạp
    final rooms = [
      {
        'id': 'r1',
        'cinemaId': '1',
        'name': 'P01',
        'type': 'IMAX',
        'capacity': 100
      },
      {
        'id': 'r2',
        'cinemaId': '1',
        'name': 'P02',
        'type': '2D',
        'capacity': 80
      },
      {
        'id': 'r3',
        'cinemaId': '2',
        'name': 'L01',
        'type': '2D',
        'capacity': 120
      },
      {
        'id': 'r4',
        'cinemaId': '2',
        'name': 'L02',
        'type': 'Gold Class',
        'capacity': 40
      },
      {
        'id': 'r5',
        'cinemaId': '3',
        'name': 'B01',
        'type': '2D',
        'capacity': 90
      },
      {
        'id': 'r6',
        'cinemaId': '4',
        'name': 'G01',
        'type': '2D',
        'capacity': 110
      },
      {
        'id': 'r7',
        'cinemaId': '5',
        'name': 'V01',
        'type': '2D',
        'capacity': 100
      },
    ];
    for (var room in rooms) {
      await db.insert('rooms', room);
    }

    // Seed Showtimes cho các phim đang chiếu
    final showtimes = [
      // Avengers (id: 1)
      {
        'id': 's1',
        'movieId': '1',
        'roomId': 'r1',
        'date': '24/10/2024',
        'time': '10:00',
        'startTime': '10:00',
        'endTime': '12:22'
      },
      {
        'id': 's2',
        'movieId': '1',
        'roomId': 'r3',
        'date': '24/10/2024',
        'time': '14:30',
        'startTime': '14:30',
        'endTime': '16:52'
      },
      // Lật mặt (id: 2)
      {
        'id': 's3',
        'movieId': '2',
        'roomId': 'r2',
        'date': '24/10/2024',
        'time': '09:00',
        'startTime': '09:00',
        'endTime': '11:00'
      },
      {
        'id': 's4',
        'movieId': '2',
        'roomId': 'r5',
        'date': '24/10/2024',
        'time': '13:00',
        'startTime': '13:00',
        'endTime': '15:00'
      },
      // Frozen 2 (id: 5)
      {
        'id': 's5',
        'movieId': '5',
        'roomId': 'r4',
        'date': '24/10/2024',
        'time': '11:00',
        'startTime': '11:00',
        'endTime': '12:43'
      },
      {
        'id': 's6',
        'movieId': '5',
        'roomId': 'r7',
        'date': '24/10/2024',
        'time': '15:00',
        'startTime': '15:00',
        'endTime': '16:43'
      },
    ];
    for (var st in showtimes) {
      await db.insert('showtimes', st);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT,
        phone TEXT,
        avatar TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE banners (
        image TEXT NOT NULL,
        title TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE movies (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        image TEXT,
        genre TEXT,
        categoryId TEXT,
        status TEXT,
        durationMinutes INTEGER,
        releaseDate TEXT,
        description TEXT,
        rating REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE cinemas (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT,
        image TEXT,
        city TEXT,
        brand TEXT,
        latitude REAL,
        longitude REAL,
        phone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE rooms (
        id TEXT PRIMARY KEY,
        cinemaId TEXT,
        name TEXT,
        type TEXT,
        capacity INTEGER,
        FOREIGN KEY (cinemaId) REFERENCES cinemas (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE showtimes (
        id TEXT PRIMARY KEY,
        movieId TEXT,
        roomId TEXT,
        date TEXT,
        time TEXT,
        startTime TEXT,
        endTime TEXT,
        FOREIGN KEY (movieId) REFERENCES movies (id),
        FOREIGN KEY (roomId) REFERENCES rooms (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE foods (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        price INTEGER,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE vouchers (
        id TEXT PRIMARY KEY,
        code TEXT UNIQUE NOT NULL,
        title TEXT,
        description TEXT,
        discountValue INTEGER,
        minOrderValue INTEGER,
        expiryDate TEXT,
        iconType TEXT,
        isUsed INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE tickets (
        id TEXT PRIMARY KEY,
        movie_json TEXT NOT NULL,
        cinemaName TEXT NOT NULL,
        showDate TEXT NOT NULL,
        showTime TEXT NOT NULL,
        seats_json TEXT NOT NULL,
        foods_json TEXT NOT NULL,
        totalAmount INTEGER NOT NULL,
        bookingDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id TEXT PRIMARY KEY,
        userId TEXT,
        movieId TEXT,
        ratingMovie REAL,
        ratingCinema REAL,
        ratingFood REAL,
        comment TEXT,
        imagePath TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        userId TEXT,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        date TEXT NOT NULL,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

// ----- USER OPERATIONS -----
  Future<void> insertUser(UserModel user) async {
// ... existing code ...
    Future<UserModel?> getUser(String email, String password) async {
      final db = await instance.database;
      final maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      }
      return null;
    }

    Future<UserModel?> getUserById(String id) async {
      final db = await instance.database;
      final maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return UserModel.fromMap(maps.first);
      }
      return null;
    }

    Future<void> updateUser(UserModel user) async {
      final db = await instance.database;
      await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }

// ----- NOTIFICATION OPERATIONS -----
    Future<void> insertNotification(Map<String, dynamic> notification) async {
      final db = await instance.database;
      await db.insert('notifications', notification,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<Map<String, dynamic>>> getNotificationsByUser(
        String userId) async {
      final db = await instance.database;
// Sắp xếp ngày mới nhất lên đầu
      return await db.query('notifications', where: 'userId = ?',
          whereArgs: [userId],
          orderBy: 'date DESC');
    }

    Future<void> markNotificationAsRead(String id) async {
      final db = await instance.database;
      await db.update(
          'notifications', {'isRead': 1}, where: 'id = ?', whereArgs: [id]);
    }

// ----- TICKET OPERATIONS -----
    Future<void> insertTicket(Ticket ticket) async {
      final db = await instance.database;
      await db.insert('tickets', ticket.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<Ticket>> getAllTickets() async {
      final db = await instance.database;
      final orderBy = 'bookingDate DESC';
      final result = await db.query('tickets', orderBy: orderBy);

      return result.map((json) => Ticket.fromMap(json)).toList();
    }

    Future<void> deleteTicket(String id) async {
      final db = await instance.database;
      await db.delete('tickets', where: 'id = ?', whereArgs: [id]);
    }

    // ----- REVIEW OPERATIONS -----
    Future<void> insertReview(ReviewModel review) async {
      final db = await instance.database;
      await db.insert('reviews', review.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<List<ReviewModel>> getReviewsByMovie(String movieId) async {
      final db = await instance.database;
      final result = await db.query(
          'reviews', where: 'movieId = ?', whereArgs: [movieId]);
      return result.map((json) => ReviewModel.fromMap(json)).toList();
    }

    // ----- MASTER DATA OPERATIONS -----
    Future<List<Movie>> getMoviesByStatus(String status) async {
      final db = await instance.database;
      final result = await db.query(
          'movies', where: 'status = ?', whereArgs: [status]);
      return result.map((json) => Movie.fromJson(json)).toList();
    }

    Future<List<Movie>> getMoviesByCategory(String categoryId) async {
      final db = await instance.database;
      if (categoryId == 'all') {
        final result = await db.query('movies');
        return result.map((json) => Movie.fromJson(json)).toList();
      }
      final result = await db.query(
          'movies', where: 'categoryId = ?', whereArgs: [categoryId]);
      return result.map((json) => Movie.fromJson(json)).toList();
    }

    Future<List<CategoryModel>> getAllCategories() async {
      final db = await instance.database;
      final result = await db.query('categories');
      return result.map((json) => CategoryModel.fromJson(json)).toList();
    }

    Future<List<BannerItem>> getAllBanners() async {
      final db = await instance.database;
      final result = await db.query('banners');
      return result.map((json) =>
          BannerItem(
            image: json['image'] as String,
            title: json['title']?.toString() ?? '',
          )).toList();
    }

    // ----- CINEMA & SHOWTIME OPERATIONS -----
    Future<List<CinemaModel>> getAllCinemas(
        {String? city, String? brand}) async {
      final db = await instance.database;
      String? where;
      List<dynamic> whereArgs = [];

      if (city != null && city != 'Tất cả') {
        where = (where == null) ? 'city = ?' : '$where AND city = ?';
        whereArgs.add(city);
      }
      if (brand != null && brand != 'Tất cả') {
        where = (where == null) ? 'brand = ?' : '$where AND brand = ?';
        whereArgs.add(brand);
      }

      final result = await db.query(
          'cinemas', where: where, whereArgs: whereArgs);
      return result.map((json) => CinemaModel.fromJson(json)).toList();
    }

    Future<List<String>> getCinemaBrands() async {
      final db = await instance.database;
      final result = await db.rawQuery('SELECT DISTINCT brand FROM cinemas');
      return result.map((row) => row['brand'] as String).toList();
    }

    Future<CinemaModel?> getCinemaById(String id) async {
      final db = await instance.database;
      final result = await db.query(
          'cinemas', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return CinemaModel.fromJson(result.first);
      }
      return null;
    }

    Future<List<RoomModel>> getRoomsByCinemaId(String cinemaId) async {
      final db = await instance.database;
      final result = await db.query(
          'rooms', where: 'cinemaId = ?', whereArgs: [cinemaId]);
      return result.map((json) => RoomModel.fromMap(json)).toList();
    }

    Future<List<ShowtimeDbModel>> getShowtimesByRoomId(String roomId) async {
      final db = await instance.database;
      final result = await db.query(
          'showtimes', where: 'roomId = ?', whereArgs: [roomId]);
      return result.map((json) => ShowtimeDbModel.fromMap(json)).toList();
    }

    Future<Movie?> getMovieById(String id) async {
      final db = await instance.database;
      final result = await db.query('movies', where: 'id = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return Movie.fromJson(result.first);
      }
      return null;
    }
  }
}