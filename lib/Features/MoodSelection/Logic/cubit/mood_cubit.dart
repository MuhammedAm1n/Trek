import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/MoodRepo.dart';
part 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepo moodRepo;
  MoodCubit(this.moodRepo) : super(MoodInitial());

  initDb() {
    moodRepo.SetinitDb();
    emit(MoodInitial());
  }

  Future<List<Map>> emitGetMood() async {
    emit(GetMoodLoading());
    return await moodRepo.GetMood();
  }

  void emitInsertMood(MoodModel moodModel) {
    emit(InsertMoodLoading());
    try {
      dynamic response = moodRepo.insertMood(moodModel);
      print('Sucess');
      if (response != null) {
        emit(InsertMoodSuccess());
      }
    } on Exception catch (e) {
      emit(InsertMoodFailuer(messge: e.toString()));
    }
  }

  void emitDeleteMood(int id) {
    emit(InsertMoodLoading());
    try {
      moodRepo.deleteMood(id);
      emit(InsertMoodSuccess());
    } on Exception catch (e) {
      emit(InsertMoodFailuer(messge: e.toString()));
    }
  }
}
