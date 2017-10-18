import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Data model for a single alarm item
// name: String type, a date in a format of TimeOfDay.toString()
// value: int type, ...
// Use helper class to convert between TimeOfDay and String.
class AlarmDataModel {
  Database _database;
  // Setup all necesary settings.
  Future<Null> Init() async {
    _database = await _createDbAndTableIfNotExist();
  }

  Future<Database> _createDbAndTableIfNotExist() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "alarms.db");

    // Delete the database
    //deleteDatabase(path);
    //return;
    print('open');
    // Check database.
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ALARMS (id INTEGER PRIMARY KEY, name TEXT, value INTEGER)");
    });
    return database;
  }

  Future<int> Insert(String name, int data) async {
    return await _database.rawInsert(
        'INSERT INTO ALARMS(name, value) VALUES("$name", $data)');
  }

  Future<List<Map>> SelectAll() async {
    return await _database.rawQuery('SELECT * FROM ALARMS');
  }

  Future<Null> Delete(int id) async {
    await _database.rawDelete('DELETE FROM ALARMS WHERE id = ?', [id]);
  }
}
