import 'package:bloc/bloc.dart';
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
      await loginRepo.LoginRep(email.text, password.text);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
