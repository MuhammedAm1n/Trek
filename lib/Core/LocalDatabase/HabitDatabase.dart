import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';

class HabitDatabase {
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
    String dBpath = join(path, 'habits.db');
    Database myDb = await openDatabase(dBpath, onCreate: _onCreate, version: 1);
    return myDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE habits(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      habitName TEXT,
      timeSpent INTEGER,
      timeGoal INTEGER,
      paused INTEGER DEFAULT 1
    )
  ''');

    print('Database Created');
  }

  Future<int> insertHabit(Map<String, dynamic> habit) async {
    Database? myDatabase = await db;
    return await myDatabase!.insert('habits', habit);
  }

  readAllHabits() async {
    Database? myDatabase = await db;
    final result = await myDatabase!.query('habits');
    return result.map((e) => HabitModel.fromMap(e)).toList();
  }

  Future<int> updateHabit(Map<String, dynamic> habit) async {
    Database? myDatabase = await db;
    final id = habit['id'];
    return await myDatabase!
        .update('habits', habit, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHabit(int id) async {
    Database? myDatabase = await db;
    return await myDatabase!.delete('habits', where: 'id = ?', whereArgs: [id]);
  }
}
