import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:video_diary/Features/Login/Data/Repositry/Repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  LoginCubit(this.loginRepo) : super(LoginInitial());
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void emitLogin() async {
    emit(LoginLoading());
    try {
      final response = await loginRepo.LoginRep(email.text, password.text);
      if (response != null ||
          response != FirebaseAuthException ||
          response != Exception) {
        emit(LoginSuccess(response));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
