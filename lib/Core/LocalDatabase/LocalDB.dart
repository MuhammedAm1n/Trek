import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

class LocalDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  initDb() async {
    String path = await getDatabasesPath();
    String dBpath = join(path, 'emotions.db');
    Database myDb = await openDatabase(dBpath, onCreate: _onCreate, version: 1);
    return myDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE emotions(
id INTEGER PRIMARY KEY, mood REAL, date TEXT, path TEXT,thumb TEXT,label TEXT,
r0 INTEGER, r1 INTEGER, r2 INTEGER, r3 INTEGER, r4 INTEGER, r5 INTEGER, 
r6 INTEGER, r7 INTEGER, r8 INTEGER, r9 INTEGER, r10 INTEGER, r11 INTEGER ) 
  ''');

    print('Database Created');
  }

  readMood() async {
    try {
      Database? myDatabase = await db;
      final response = await myDatabase!.query("emotions");
      print(response);
      return response.map((e) => MoodModel.map(e)).toList();
    } on Exception catch (e) {
      throw (e.toString());
    }
  }

  insertMood(MoodModel newMood) async {
    Database? myDatabase = await db;
    int response = await myDatabase!.rawInsert('''
        INSERT INTO 'emotions' (
          mood, date, path, thumb,label, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11
        ) VALUES (? , ? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?,?)
      ''', newMood.dbEntry());
    print('Done');
    return response;
  }

  deleteMood(int id) async {
    Database? myDatabase = await db;
    int response =
        await myDatabase!.rawDelete("DELETE FROM 'emotions' WHERE id = $id ");
    return response;
  }

  Future<int> updateMood(Map<String, dynamic> mood) async {
    Database? myDatabase = await db;
    final id = mood['id'];
    return await myDatabase!
        .update('emotions', mood, where: 'id = ?', whereArgs: [id]);
  }
}
