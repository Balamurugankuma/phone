import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Database_connection {
  Future<Database> setdatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'contacts.db');
    var database = openDatabase(path, version: 1, onCreate: _create);

    return database;
  }

  Future<void> _create(Database database, int version) async {
    String sql = '''
    CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone_number TEXT
      );
    ''';
    await database.execute(sql);
  }
}
