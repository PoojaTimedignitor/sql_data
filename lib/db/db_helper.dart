import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  DBHelper._internal();                                        /// Singleton
  static final DBHelper instance = DBHelper._internal();

  static Database? _database;

   Future<Database> get database async{
      if(_database != null) return _database!;
      _database = await _initDatabase();
      return _database!;
  }

   Future<Database> _initDatabase() async {
  // static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

   Future<void> _createDatabase(Database db, int version) async {                                                      /// remove static
  // static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
         CREATE TABLE IF NOT EXISTS users(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         firstName TEXT,
         lastName TEXT,
         age INTEGER
         )
        ''');
  }

   Future<int> insertUser(String firstName, String lastName, int age) async {
    final db = await database;                                                                  /// singleton
    // final db = await _initDatabase();
    final data = {'firstName': firstName, 'lastName': lastName, 'age': age};
    return await db.insert('users', data);
  }

   Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    // final db = await _initDatabase();
    //return await db.query('users');                                                               /// asc
    return await db.query('users', orderBy: 'id DESC');
  }

   Future<int> deleteData(int id) async {
    final db = await database;
    // final db = await _initDatabase();
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

   Future<Map<String, dynamic>?> getSingleData(int id) async {
    final db = await database;
    // final db = await _initDatabase();
    List<Map<String, dynamic>> result =
        await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

   Future<int> updateData(int id, Map<String, dynamic> data) async {
    final db = await database;
    // final db = await _initDatabase();
    return await db.update('users', data, where: 'id = ?', whereArgs: [id]);
  }
}
