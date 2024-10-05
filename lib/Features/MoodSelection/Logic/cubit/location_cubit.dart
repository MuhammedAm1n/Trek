import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/LocationRepo.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepo locationRepo;
  LocationCubit(this.locationRepo) : super(LocationInitial());

  Future<String> emitGetLocation() async {
    emit(LocationLoading());
    try {
      final city = await locationRepo.getLocation();
      emit(LocationSucess(Location: city));
    } on Exception catch (e) {
      emit(LocationFaliuer(message: e.toString()));
    }
    return "";
  }
}
