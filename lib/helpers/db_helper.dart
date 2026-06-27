import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ticket_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('popcorngo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
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
  }

  Future<void> insertTicket(Ticket ticket) async {
    final db = await instance.database;
    await db.insert('tickets', ticket.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ticket>> getAllTickets() async {
    final db = await instance.database;
    final orderBy = 'bookingDate DESC';
    final result = await db.query('tickets', orderBy: orderBy);

    return result.map((json) => Ticket.fromMap(json)).toList();
  }

  Future<void> deleteTicket(String id) async {
    final db = await instance.database;
    await db.delete(
      'tickets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
