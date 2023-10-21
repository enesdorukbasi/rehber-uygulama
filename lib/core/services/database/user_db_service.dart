import 'package:enes_dorukbasi/core/services/database/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class UserProfileServiceByDB {
  final tableNameForUserProfile = "accountModel";

  Future<void> createTable(Database database) async {
    await database
        .execute("""CREATE TABLE IF NOT EXISTS $tableNameForUserProfile (
      "id" INTEGER NOT NULL,
      "mail" TEXT NOT NULL,
      "password" TEXT NOT NULL,
      PRIMARY KEY("id" AUTOINCREMENT)
    );""");
  }

  Future<int> insert({required String mail, required String password}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableNameForUserProfile (mail, password) VALUES (?,?)''',
      [mail, password],
    );
  }

  Future<void> delete() async {
    try {
      final database = await DatabaseService().database;
      final items =
          await database.rawQuery('''SELECT * FROM $tableNameForUserProfile''');
      if (items.isNotEmpty) {
        String data = items[0]['id'].toString();
        int id = int.parse(data);
        await database.rawDelete(
            '''DELETE FROM $tableNameForUserProfile WHERE id = ?''', [id]);
        return;
      } else {
        return;
      }
    } catch (ex) {
      if (kDebugMode) {
        print("Hata :: $ex");
      }
    }
  }

  Future<Map<String, dynamic>?> fetchData() async {
    final database = await DatabaseService().database;
    final items =
        await database.rawQuery('''SELECT * FROM $tableNameForUserProfile''');
    if (items.isNotEmpty) {
      return items[0];
    } else {
      return null;
    }
  }
}
