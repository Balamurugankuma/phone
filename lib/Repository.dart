import 'package:sqflite/sqflite.dart';
import 'package:untitled19/databaseccnnection.dart';

class Repository {
  late Database_connection database_connection;
  Repository() {
    database_connection = Database_connection();
  }
  static Database? database;
  Future<Database?> get data_base async {
    if (database != null) {
      return database!;
    } else {
      var database = database_connection.setdatabase();
      return database;
    }
  }

  insertdata(table, data) async {
    var db = await data_base;
    return await db?.insert(table, data);
  }

  read_data(table) async {
    var db = await data_base;
    return await db?.query(table);
  }

  update_data(table, data) async {
    var db = await data_base;
    return db?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  delete_data(table, id) async {
    var db = await data_base;
    return await db?.rawDelete("delete from $table where id=$id");
  }

  Future<List<Map<String, dynamic>>?> search_data(
    String table,
    String keyword,
  ) async {
    var db = await data_base;
    return await db?.query(
      table,
      where: "name LIKE ? OR phone_number LIKE ?",
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
  }
}
