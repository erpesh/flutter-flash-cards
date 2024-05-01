import 'package:flash_cards/services/database_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Ref - https://stackoverflow.com/a/71136958
// Ref - https://github.com/tekartik/sqflite/blob/master/sqflite/doc/testing.md

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();

  test('DatabaseServices Functions Test', () async {
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    await _createDatabase(db, 1);

    await DatabaseServices.saveTestResult('Test Set 1', 75.5);

    List<Map<String, dynamic>> results = await DatabaseServices.getAllTestResults();

    expect(results.length, 1);
    expect(results[0]['cardsSetName'], 'Test Set 1');
    expect(results[0]['percentage'], 75.5);

    await DatabaseServices.saveTestResult('Test Set 2', 85.5);

    int insertedId = results[0]['id'];
    await DatabaseServices.deleteTestResult(insertedId);

    List<Map<String, dynamic>> updatedResults = await DatabaseServices.getAllTestResults();
    expect(updatedResults.length, 1);

    // Clear database
    await DatabaseServices.deleteAllTestResults();
    await db.close();
  });
}

Future<void> _createDatabase(Database database, int version) async {
  const String sql =
      'CREATE TABLE IF NOT EXISTS testResults(id INTEGER PRIMARY KEY AUTOINCREMENT, cardsSetName TEXT, percentage REAL)';
  await database.execute(sql);
}
