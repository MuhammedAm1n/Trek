import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/MoodRepo.dart';
part 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepo moodRepo;
  List<MoodModel> moods = [];
  MoodCubit(this.moodRepo) : super(MoodInitial());

  initDb() {
    moodRepo.SetinitDb();
    emit(MoodInitial());
  }

  List<MoodModel> emitGetMood() {
    emit(GetMoodLoading());
    moodRepo.GetMood().then((moods) {
      emit(GetMoodSuccess(moods: moods));
      this.moods = moods;
    });
    return moods;
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
    emit(DeleteMoodLoading());
    try {
      moodRepo.deleteMood(id);
      emit(DeleteMoodSuccess());
    } on Exception catch (e) {
      emit(DeleteMoodFailuer(messge: e.toString()));
    }
  }
}
