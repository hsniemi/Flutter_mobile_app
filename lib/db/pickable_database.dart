import 'package:flutter_app_summer_project/model/location.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app_summer_project/model/pickable.dart';

import '../model/city.dart';

/*
This class contains creating the SQLite database, creating tables to the database
and all the database queries used by the application.
*/

class PickableDatabase {
  static final PickableDatabase instance = PickableDatabase._init();

//Abstract class Database from sqflite package for creating a database.
  static Database? _database;

//Execute a command for allowing use of foreign keys.
//Called for onConfigure argument in openDatabase method.
  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  PickableDatabase._init();

//A getter method for database, which returns a
//a Database instance _database.
  Future<Database> get database async {
    if (_database != null) return _database!;

    //Call _initDB method if Database isn't initialized and
    //store the resulting Database instance to _database.
    _database = await _initDB('pickable.db');
    return _database!;
  }

//Open db and initialize it, return a Database instance.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, //Call _createDB to create the tables.
      onConfigure: _onConfigure,
    );
  }

  Future _createDB(Database db, int version) async {
    final textId = 'TEXT PRIMARY KEY';
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $pickables (
  ${PickableFields.id} $idType,
  ${PickableFields.name} $textType,
  ${PickableFields.totalAmount} $realType,
  ${PickableFields.unit} $textType
)
''');

    await db.execute('''
CREATE TABLE $history (
  ${HistoryFields.id} $idType,
  ${HistoryFields.pickable_id} INTEGER NOT NULL,
  ${HistoryFields.amount} $realType,
  ${HistoryFields.date} $textType,
  ${HistoryFields.notes} TEXT,
  FOREIGN KEY(pickable_id) REFERENCES pickables(_id)
)
''');

    await db.execute('''
CREATE TABLE $place(
  ${PlaceField.id} $idType,
  ${PlaceField.date} $textType,
  ${PlaceField.title} TEXT,
  ${PlaceField.description} TEXT,
  ${PlaceField.latitude} $realType,
  ${PlaceField.longitude} $realType
  )
  ''');

    await db.execute('''
CREATE TABLE weather(
  _id $idType,
  city_name TEXT
  )
  ''');

    await db.rawInsert('''
    INSERT INTO weather(city_name) VALUES('');
''');
  }

  Future<Pickable> createPickable(Pickable pickable) async {
    final db = await instance.database;

    final id = await db.insert(pickables, pickable.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return pickable.copy(id: id);
  }

  Future<PickableHistory> createHistory(PickableHistory historyItem) async {
    final db = await instance.database;

    final id = await db.insert(history, historyItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return historyItem.copy(id: id);
  }

//Get all items from table pickables.
  Future<List<Pickable>> readPickables() async {
    final db = await instance.database;

    final result = await db.query(pickables);
    return result.map((e) => Pickable.fromMap(e)).toList();
  }

  //Get all histories with given name.
  Future<List<PickableHistory>> readHistories(int id) async {
    final db = await instance.database;
    final result = await db.query(
      history,
      where: '${HistoryFields.pickable_id} = ?',
      orderBy: '${HistoryFields.date} DESC',
      whereArgs: [id],
    );
    return result.map((e) => PickableHistory.fromMap(e)).toList();
  }

  Future<City> readCity() async {
    final db = await instance.database;

    final result = await db.rawQuery('''
      SELECT city_name FROM weather WHERE _id = 1;
''');
    return result.map((e) => City.fromMap(e)).first;
  }

  Future<void> updateCity(String city) async {
    final db = await instance.database;

    db.rawUpdate('''
UPDATE weather SET city_name = ? WHERE _id = 1;
''', [city]);
  }

  Future updatePickable(Pickable pickable) async {
    final db = await instance.database;

    return db.update(
      pickables,
      pickable.toMap(),
      where: '${PickableFields.id} = ?',
      whereArgs: [pickable.id],
    );
  }

  Future updateTotalAmount(int id, double amount) async {
    final db = await instance.database;
    return db.rawQuery(
      '''
UPDATE pickables SET total_amount = ? WHERE _id = ?;
''',
      [amount, id],
    );
  }

  Future<int> updateHistory(PickableHistory historyItem) async {
    final db = await instance.database;

    return db.update(
      history,
      historyItem.toMap(),
      where: '${HistoryFields.id} = ?',
      whereArgs: [historyItem.id],
    );
  }

  Future<int> deletePickable(int id) async {
    final db = await instance.database;

    return await db.delete(
      pickables,
      where: '${PickableFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteHistory(int id) async {
    final db = await instance.database;

    return await db.delete(
      history,
      where: '${HistoryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllHistories(int id) async {
    final db = await instance.database;

    return await db.delete(
      history,
      where: '${HistoryFields.pickable_id} = ?',
      whereArgs: [id],
    );
  }

  Future<Place> createPlace(Place placeItem) async {
    final db = await instance.database;

    final id = await db.insert('place', placeItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return placeItem.copy(id: id);
  }

  Future<List<Place>> readPlace() async {
    final db = await instance.database;

    final result = await db.query(place);
    return result.map((e) => Place.fromMap(e)).toList();
  }

  Future<int> deletePlace(int id) async {
    final db = await instance.database;

    return await db.delete(
      place,
      where: '${PlaceField.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
