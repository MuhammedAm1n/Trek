import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/UploadtoDrive/Data/Repo/GdriveRepo.dart';

part 'gdrive_state.dart';

class GdriveCubit extends Cubit<GdriveState> {
  final Gdriverepo gdriverepo;
  GdriveCubit(this.gdriverepo) : super(GdriveInitial());

  uploadTreks() async {
    emit(GdriveLoading());
    try {
      emit(GdriveLoading());
      await gdriverepo.uploadVideos();
      emit(GdriveSucess());
    } on Exception catch (e) {
      if (e is PathNotFoundException) {
        emit(GdriveFaliuer(message: "There is no videos to backup"));
      } else {
        emit(GdriveFaliuer(message: e.toString()));
      }
    }
  }
}
