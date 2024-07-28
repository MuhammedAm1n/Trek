import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/MoodRepo.dart';
part 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepo moodRepo;
  List<MoodModel> moods = [];

  MoodCubit(this.moodRepo) : super(MoodInitial());

  void initDb() {
    moodRepo.SetinitDb();
    emit(MoodInitial());
  }

  Future<void> loadMood() async {
    emit(GetMoodLoading());
    try {
      final moods = await moodRepo.GetMood();
      this.moods = moods;
      emit(GetMoodSuccess(moods: moods));
    } catch (e) {
      emit(GetMoodFailure(message: e.toString()));
    }
  }

  Future<void> insertMood(MoodModel moodModel) async {
    emit(InsertMoodLoading());
    try {
      await moodRepo.insertMood(moodModel);
      emit(InsertMoodSuccess());
    } catch (e) {
      emit(InsertMoodFailure(message: e.toString()));
    }
  }

  deleteMood(int id) async {
    emit(DeleteMoodLoading());
    try {
      await moodRepo.deleteMood(id);
      emit(DeleteMoodSuccess());
    } catch (e) {
      emit(DeleteMoodFailure(message: e.toString()));
    }
  }

  Future<void> updateMood(MoodModel mood) async {
    emit(UpdateMoodLoading());
    try {
      await moodRepo.updateMood(mood);
      final updatedMoods = this.moods.map((existingMood) {
        if (existingMood.id == mood.id) {
          return mood;
        }
        return existingMood;
      }).toList();
      emit(UpdateMoodSuccess(moods: updatedMoods));
    } catch (e) {
      emit(UpdateMoodFailure(message: e.toString()));
    }
  }

  void toggleFavorite(int diaryId) async {
    if (state is GetMoodSuccess) {
      final currentState = state as GetMoodSuccess;
      final updatedMoods = currentState.moods.map((mood) {
        if (mood.id == diaryId) {
          return mood.copyWith(
              favorite: !mood.favorite); // Toggle the favorite status
        }
        return mood;
      }).toList();

      // Update the repository with the new favorite status
      try {
        final updatedMood =
            updatedMoods.firstWhere((mood) => mood.id == diaryId);
        await moodRepo.updateMood(updatedMood);

        // Emit the updated state with the modified list of moods
        emit(GetMoodSuccess(moods: updatedMoods));
      } catch (e) {
        // Handle the error if updating the repository fails
        emit(GetMoodFailure(message: e.toString()));
      }
    }
  }
}
