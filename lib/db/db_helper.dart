import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = "typing_test.db";
  static const String tableName = "results";
  static const int version = 1;

  static const String columnId = "id";
  static const String columnWpm = "wpm";
  static const String columnAccuracy = "accuracy";
  static const String columnDate = "date";

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: version,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnWpm INTEGER NOT NULL,
            $columnAccuracy REAL NOT NULL,
            $columnDate TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Insert result
  static Future<int> insertResult(int wpm, double accuracy) async {
    final dbClient = await db;
    return await dbClient.insert(tableName, {
      columnWpm: wpm,
      columnAccuracy: accuracy,
      columnDate: DateFormat("d MMMM yyyy : h:mm a").format(DateTime.now()),
    });
  }

  /// Fetch all results
  static Future<List<Map<String, dynamic>>> getResults() async {
    final dbClient = await db;
    return await dbClient.query(tableName, orderBy: "$columnId DESC");
  }

  /// Clear all results
  static Future<int> clearResults() async {
    final dbClient = await db;
    return await dbClient.delete(tableName);
  }
}
