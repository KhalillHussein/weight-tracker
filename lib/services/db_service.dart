///Импорт необходимых модулей для класса [DbService]
///Модуль [sqflite] добавляет возможность создания локальной базы данных [sqlite].
///Локальная база данных создается и хранится на устройстве пользователя.
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

///Модуль [path] добавляет возможность управления путями.
///С помощью данного модуля выполняется операция создания пути до файла БД.
import 'package:path/path.dart' as path;

///Класс, выполняющий [CRUD] операции с базой данных [sqflite].
///Данный класс является синглтоном.
///Т.о. для доступа к полям класса доступен лишь один экземпляр,
///созданный внутри данного класса, доступный из любой точки приложения.
class DbService {
  //Создаем приватный конструктор класса
  DbService._();
  //Создаем статический объект класса.
  // Через него будем обращаться к свойствам класса из любой точки приложения
  static final DbService db = DbService._();

  //переменная объекта Database
  Database _database;

  ///Асинхронный метод get для получения переменной объекта Database
  Future<Database> get database async {
    //Если значение переменной не пусто(null), то возвращаем ее
    if (_database != null) return _database;
    //Иначе инициализируем объектом Database
    _database = await getDatabaseInstance();
    return _database;
  }

  ///Асинхронный метод для получения объекта базы данных
  Future<Database> getDatabaseInstance() async {
    //Определяение базового расположения базы данных
    final dbPath = await sql.getDatabasesPath();
    //Создание/Открытие(если существует) файла базы данных user.db
    return sql.openDatabase(path.join(dbPath, 'user.db'),
        onCreate: (db, version) => _createDb(db), version: 1);
  }

  ///Асинхронный метод, выполняющий запрос на создание таблицы базы данных.
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
    await db.execute("""
        CREATE TABLE calories
        (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        count INTEGER,
        calories REAL,
        date INTEGER
        )
        """);
  }

  ///Асинхронный метод, выполняющий запрос на вставку данных в таблицу.
  Future<void> insert(Map<String, dynamic> data, String table) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///Асинхронный метод, выполняющий запрос на получение всех данных из таблицы.
  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database;
    return db.query(table);
  }

  ///Асинхронный метод, выполняющий запрос на удаление данных с указанным id.
  Future<void> deleteItem(int id, String table) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  ///Асинхронный метод, выполняющий запрос на удаление БД.
  Future<void> deleteDatabase() async {
    final String databasesPath = await sql.getDatabasesPath();
    final String pathToDb = path.join(databasesPath, 'user.db');
    await sql.deleteDatabase(pathToDb);
  }
}
