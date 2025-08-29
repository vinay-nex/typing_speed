import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = "typing_test.db";
  static const String resultsTable = "results";
  static const String userTable = "user";

  static const int version = 1;

  // Results columns
  static const String columnId = "id";
  static const String columnWpm = "wpm";
  static const String columnAccuracy = "accuracy";
  static const String columnDate = "date";

  // User columns
  static const String columnUserId = "id";
  static const String columnUserName = "name";

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
        // Create results table
        await db.execute('''
          CREATE TABLE $resultsTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnWpm INTEGER NOT NULL,
            $columnAccuracy REAL NOT NULL,
            $columnDate TEXT NOT NULL
          )
        ''');

        // Create user table
        await db.execute('''
          CREATE TABLE $userTable (
            $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserName TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Insert typing result
  static Future<int> insertResult(int wpm, double accuracy) async {
    final dbClient = await db;
    return await dbClient.insert(resultsTable, {
      columnWpm: wpm,
      columnAccuracy: accuracy,
      columnDate: DateFormat("d MMMM yyyy : h:mm a").format(DateTime.now()),
    });
  }

  /// Fetch all results (latest first)
  static Future<List<Map<String, dynamic>>> getResults() async {
    final dbClient = await db;
    return await dbClient.query(resultsTable, orderBy: "$columnId DESC");
  }

  /// Clear all results
  static Future<int> clearResults() async {
    final dbClient = await db;
    return await dbClient.delete(resultsTable);
  }

  /// ================= USER TABLE FUNCTIONS =================

  /// Insert user name
  static Future<int> insertUser(String name) async {
    final dbClient = await db;
    return await dbClient.insert(userTable, {
      columnUserName: name,
    });
  }

  /// Get the latest user name
  static Future<String?> getUser() async {
    final dbClient = await db;
    final result = await dbClient.query(userTable, orderBy: "$columnUserId DESC", limit: 1);
    if (result.isNotEmpty) {
      return result.first[columnUserName] as String;
    }
    return null;
  }

  /// Update user name (optional)
  static Future<int> updateUser(String name) async {
    final dbClient = await db;
    final idResult = await getUserId();
    if (idResult != null) {
      return await dbClient.update(userTable, {columnUserName: name}, where: "$columnUserId = ?", whereArgs: [idResult]);
    } else {
      return insertUser(name);
    }
  }

  /// Get latest user ID
  static Future<int?> getUserId() async {
    final dbClient = await db;
    final result = await dbClient.query(userTable, orderBy: "$columnUserId DESC", limit: 1);
    if (result.isNotEmpty) {
      return result.first[columnUserId] as int;
    }
    return null;
  }
}
