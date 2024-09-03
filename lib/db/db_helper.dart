import 'package:restoranapp/ui/model/resto_model.dart';
import 'package:sqflite/sqflite.dart';

class Databasehelper {
  static Databasehelper? _instance;
  static Database? _database;

  Databasehelper._internal() {
    _instance = this;
  }

  factory Databasehelper() => _instance ?? Databasehelper._internal();

  static const String _tblBookmark = "Bookmarks";

  Future<Database> _initializedb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBookmark (
      id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
        )''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializedb();

    return _database;
  }

  Future<void> insertBookmark(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblBookmark, restaurant.toJson());
  }

  Future<List<Restaurant>> getBookmark() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBookmark);

    return results.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<Map> getBookmarkbyId(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results =
        await db!.query(_tblBookmark, where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBookmark(String id) async {
    final db = await database;

    await db!.delete(_tblBookmark, where: "id = ?", whereArgs: [id]);
  }
}
