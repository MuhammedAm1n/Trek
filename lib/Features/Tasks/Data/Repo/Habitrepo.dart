import 'package:video_diary/Core/LocalDatabase/HabitDatabase.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';

class TaskRepo {
  final HabitDatabase database;

  TaskRepo({required this.database});

  setinitDb() {
    database.initDb();
  }

  Future<List<TaskModel>> readHabits() async {
    final habitz = await database.readAllHabits();
    return habitz;
  }

  insertHabit(Map<String, dynamic> habit) {
    database.insertHabit(habit);
  }

  updateHabit(Map<String, dynamic> habit) {
    database.updateHabit(habit);
  }

  deleteHabit(int id) {
    database.deleteHabit(id);
  }
}
