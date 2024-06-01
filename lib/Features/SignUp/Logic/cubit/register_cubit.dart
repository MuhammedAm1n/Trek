import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_diary/Features/SignUp/Data/Repositry/RegisterRepo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordconf = TextEditingController();
  TextEditingController userName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  emitRegister() async {
    emit(RegisterLoading());
    try {
      final response =
          await registerRepo.registerRep(email.text, password.text);
      registerRepo.createUserRep(userName.text);
      if (response != null ||
          response != FirebaseAuthException ||
          response != Exception) {
        emit(RegisterSuccess());
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
