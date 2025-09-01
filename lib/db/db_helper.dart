import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/result_model.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = "typing_test.db";
  static const String resultsTable = "results";
  static const String userTable = "user";
  static const int version = 1;

  /// Results columns
  static const String columnId = "id";
  static const String columnNetSpeed = "net_speed";
  static const String columnGrossSpeed = "gross_speed";
  static const String columnKeystrokes = "keystrokes";
  static const String columnBackspace = "backspace";
  static const String columnCorrectWords = "correct_words";
  static const String columnWrongWords = "wrong_words";
  static const String columnAccuracy = "accuracy";
  static const String columnTypedText = "typed_text";
  static const String columnOriginalText = "original_text";
  static const String columnDuration = "duration";
  static const String columnMode = "mode";
  static const String columnDate = "date";
  static const String columnTime = "time";

  /// User columns
  static const String columnUserId = "id";
  static const String columnUserName = "name";

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Delete old DB
  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }
  }

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: version,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $resultsTable (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnNetSpeed INTEGER,
            $columnGrossSpeed INTEGER,
            $columnKeystrokes INTEGER,
            $columnBackspace INTEGER,
            $columnCorrectWords INTEGER,
            $columnWrongWords INTEGER,
            $columnAccuracy REAL,
            $columnTypedText TEXT,
            $columnOriginalText TEXT,
            $columnDuration TEXT,
            $columnMode TEXT,
            $columnDate TEXT,
            $columnTime TEXT
          )
        ''');

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
  static Future<int> insertResult({
    required int netSpeed,
    required int grossSpeed,
    required int keystrokes,
    required int backspace,
    required int correctWords,
    required int wrongWords,
    required double accuracy,
    required String typedText,
    required String originalText,
    required String duration,
    required String mode,
  }) async {
    final dbClient = await db;
    return await dbClient.insert(resultsTable, {
      columnNetSpeed: netSpeed,
      columnGrossSpeed: grossSpeed,
      columnKeystrokes: keystrokes,
      columnBackspace: backspace,
      columnCorrectWords: correctWords,
      columnWrongWords: wrongWords,
      columnAccuracy: accuracy,
      columnTypedText: typedText,
      columnOriginalText: originalText,
      columnDuration: duration,
      columnMode: mode,
      columnDate: DateFormat("d MMMM yyyy").format(DateTime.now()),
      columnTime: DateFormat("h:mm a").format(DateTime.now()),
    });
  }

  /// Fetch all results
  static Future<List<Map<String, dynamic>>> getResults() async {
    final dbClient = await db;
    return await dbClient.query(resultsTable, orderBy: "$columnId DESC");
  }

  /// Get latest result
  static Future<ResultModel?> getLatestResult() async {
    final dbClient = await db;
    final results = await dbClient.query(resultsTable, orderBy: "$columnId DESC", limit: 1);

    if (results.isNotEmpty) {
      return ResultModel.fromMap(results.first);
    }

    return null;
  }

  /// Get result by ID
  static Future<ResultModel?> getResultById(int id) async {
    final dbClient = await db;
    final result = await dbClient.query(
      resultsTable,
      where: "$columnId = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return ResultModel.fromMap(result.first);
    }

    return null;
  }

  /// Clear results
  static Future<int> clearResults() async {
    final dbClient = await db;
    return await dbClient.delete(resultsTable);
  }

  /// ================= USER =================
  static Future<int> insertUser(String name) async {
    final dbClient = await db;
    return await dbClient.insert(userTable, {columnUserName: name});
  }

  static Future<String?> getUser() async {
    final dbClient = await db;
    final result = await dbClient.query(userTable, orderBy: "$columnUserId DESC", limit: 1);
    if (result.isNotEmpty) {
      return result.first[columnUserName] as String;
    }
    return null;
  }

  static Future<int> updateUser(String name) async {
    final dbClient = await db;
    final idResult = await getUserId();
    if (idResult != null) {
      return await dbClient.update(userTable, {columnUserName: name}, where: "$columnUserId = ?", whereArgs: [idResult]);
    } else {
      return insertUser(name);
    }
  }

  static Future<int?> getUserId() async {
    final dbClient = await db;
    final result = await dbClient.query(userTable, orderBy: "$columnUserId DESC", limit: 1);
    if (result.isNotEmpty) {
      return result.first[columnUserId] as int;
    }
    return null;
  }
}
