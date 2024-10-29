import 'package:libraryapp/models/sync_operation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._();
  static Database? _database;

  LocalDatabaseService._();

  static LocalDatabaseService get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        function_name TEXT NOT NULL,
        params TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending'
      );
    ''');
  }

  Future<void> insertOperation(SyncOperation operation) async {
    final db = await database;
    await db.insert(
      'sync_queue',
      operation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SyncOperation>> getPendingOperations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['pending'],
    );

    return List.generate(maps.length, (i) {
      return SyncOperation.fromMap(maps[i]);
    });
  }

  Future<void> updateOperationStatus(String id, String status) async {
    final db = await database;
    await db.update(
      'sync_queue',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
