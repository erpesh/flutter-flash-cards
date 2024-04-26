import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseServices {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final databaseFile = join(databasePath, 'flash_cards.dv');
    return openDatabase(
      databaseFile,
      version: 1,
      onCreate: _createDatabase
    );
  }

  static _createDatabase(Database database, int version) {
    final String sql = 'CREATE TABLE IF NOT EXISTS testResults(id INTEGER PRIMARY KEY AUTOINCREMENT, cardsSetName TEXT, percentage REAL)';
    database.execute(sql);
  }

  static Future<int> saveTestResult(String cardsSetName, double percentage) async {
    final db = await _openDatabase();
    Map<String, dynamic> studentRecord = {
      "cardsSetName": cardsSetName,
      "percentage": percentage,
    };
    return await db.insert("testResults", studentRecord);
  }

  static Future<List<Map<String, dynamic>>> getAllTestResults() async {
    final db = await _openDatabase();
    return await db.query('testResults');
  }

  static Future<int> deleteTestResult(int id) async {
    final db = await _openDatabase();
    return await db.delete(
      'testResults',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}