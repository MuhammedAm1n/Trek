import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/LoginWithGoogle/Data/Repo/LoginWithGmailRepo.dart';
part 'login_with_google_state.dart';

class LoginWithGoogleCubit extends Cubit<LoginWithGoogleState> {
  final LoginWithGmailRepo loginWithGmailRepo;
  LoginWithGoogleCubit(this.loginWithGmailRepo)
      : super(LoginWithGoogleInitial());

  emitloginWithGooglel() async {
    emit(LoginWithGoogleLoading());
    try {
      final response = await loginWithGmailRepo.loginWithGoogleRep();

      if (response != null || response != Exception) {
        emit(LoginWithGoogleSuccess());
      }
    } on Exception catch (e) {
      LoginWithGoogleError(error: e.toString());
    }
  }
}
