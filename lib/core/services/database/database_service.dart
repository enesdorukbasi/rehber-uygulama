import 'package:enes_dorukbasi/core/services/database/user_db_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(path,
        version: 1, onCreate: create, singleInstance: true);
    return database;
  }

  Future<void> deleteDatabaseFunc() async {
    String path = await fullPath;
    await deleteDatabase(path);
  }

  Future<void> create(Database database, int version) async {
    await UserProfileServiceByDB().createTable(database);
  }

  Future<String> get fullPath async {
    const name = "enesdorukbasi.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }
}
