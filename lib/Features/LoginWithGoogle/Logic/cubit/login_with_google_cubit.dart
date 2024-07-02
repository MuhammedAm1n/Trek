import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:video_diary/Features/LoginWithGoogle/Data/Repo/LoginWithGmailRepo.dart';
part 'login_with_google_state.dart';

class LoginWithGoogleCubit extends Cubit<LoginWithGoogleState> {
  final LoginWithGmailRepo loginWithGmailRepo;
  LoginWithGoogleCubit(this.loginWithGmailRepo)
      : super(LoginWithGoogleInitial());

  Future<void> emitloginWithGooglel() async {
    try {
      emit(LoginWithGoogleLoading());

      await loginWithGmailRepo.loginWithGoogleRep();

      if (!isClosed) {
        emit(LoginWithGoogleSuccess());
      }
    } catch (e) {
      if (!isClosed && e is PlatformException) {
        emit(LoginWithGoogleError(error: e.code.toString()));
      }

      if (!isClosed && e is FirebaseException) {
        emit(LoginWithGoogleError(error: e.code.toString()));
      }
    }
  }
}
