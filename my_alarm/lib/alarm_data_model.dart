import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AlarmDataModel {
  Database _database;
  // Setup all necesary settings.
  Future<Null> Init() async {
    _database = await _createDbAndTableIfNotExist();

    // TODO(sungguk): Remove when ready;
    //await Insert("AAAA", 123);
  }

  Future<Database> _createDbAndTableIfNotExist() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "alarms.db");

    print('try open');
    // Delete the database
    //deleteDatabase(path);
    //return;
    print('open');
    // Check database.
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      print('oncreated');
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ALARMS (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });
    return database;
  }

  Future<Null> Insert(String name, int data) async {
    await _database.inTransaction(() async {
      int id1 = await _database.rawInsert(
          'INSERT INTO ALARMS(name, value, num) VALUES("some name", $data, 456.789)');
      print("inserted1: $id1");
    });
  }
}
