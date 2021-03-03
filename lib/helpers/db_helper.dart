import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  DBHelper._();
  static final DBHelper db = DBHelper._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  Future<void> _createDb(Database db) async {
    await db.execute("""
        CREATE TABLE parameters
        (
        id INTEGER PRIMARY KEY, 
        weight REAL, 
        height INTEGER,
        age INTEGER,
        bmi REAL,
        date INTEGER,
        fatPercent REAL,
        idealWeight REAL
        )
        """);
  }

  Future<void> insert(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('parameters', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return db.query('parameters');
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('parameters', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearTable() async {
    final db = await database;
    await db.delete('parameters');
  }
}
