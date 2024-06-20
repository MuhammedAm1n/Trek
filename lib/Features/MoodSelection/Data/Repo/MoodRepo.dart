import 'package:video_diary/Core/LocalDatabase/LocalDB.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

class MoodRepo {
  final LocalDb db;
  MoodRepo({required this.db});

  SetinitDb() {
    db.initDb();
  }

  Future<List<MoodModel>> GetMood() async {
    return await db.readMood();
  }

  insertMood(MoodModel newMood) {
    db.insertMood(newMood);
  }

  deleteMood(int id) {
    db.deleteMood(id);
  }
}
