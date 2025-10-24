import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'double_v.db');
    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE locations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        country INTEGER,
        department INTEGER,
        name TEXT NOT NULL,
        FOREIGN KEY(country) REFERENCES locations(id) ON DELETE SET NULL,
        FOREIGN KEY(department) REFERENCES locations(id) ON DELETE SET NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        birthDate TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE user_addresses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        locationId INTEGER NOT NULL,
        address TEXT NOT NULL,
        FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(locationId) REFERENCES locations(id) ON DELETE CASCADE
      );
    ''');

    // ====== LOCATIONS TEST ======

    int colombiaId = await db.insert('locations', {
      'country': null,
      'department': null,
      'name': 'Colombia',
    });

    int santanderId = await db.insert('locations', {
      'country': colombiaId,
      'department': null,
      'name': 'Santander',
    });

    int cundinamarcaId = await db.insert('locations', {
      'country': colombiaId,
      'department': null,
      'name': 'Cundinamarca',
    });

    await db.insert('locations', {
      'country': colombiaId,
      'department': santanderId,
      'name': 'Bucaramanga',
    });

    await db.insert('locations', {
      'country': colombiaId,
      'department': santanderId,
      'name': 'Floridablanca',
    });

    await db.insert('locations', {
      'country': colombiaId,
      'department': cundinamarcaId,
      'name': 'Bogotá',
    });

    await db.insert('locations', {
      'country': colombiaId,
      'department': cundinamarcaId,
      'name': 'Soacha',
    });
  }
}
