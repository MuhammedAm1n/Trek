import 'package:video_diary/Core/networking/ApiServices.dart';

class LoginWithGmailRepo {
  final ApiServices apiServices;

  LoginWithGmailRepo({required this.apiServices});

  Future<void> loginWithGoogleRep() async {
    await apiServices.loginWithGoogle();
  }
}
