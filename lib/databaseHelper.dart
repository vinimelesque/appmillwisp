import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "historyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'history';

  static final columnId = '_id';
  static final columnVariacaoPeso = 'variacaoPeso';
  static final columnDataHoraCompleta = 'dataHoraCompleta';
  static final columnHoraCompleta = 'horaCompleta';
  static final columnPeso = 'peso';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnVariacaoPeso TEXT NOT NULL,
        $columnDataHoraCompleta TEXT NOT NULL,
        $columnHoraCompleta TEXT NOT NULL,
        $columnPeso TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertHistory(Map<String, String> historyData) async {
    Database db = await instance.database;
    await db.insert(table, historyData);
  }

  Future<List<Map<String, dynamic>>> fetchAllHistory() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}
