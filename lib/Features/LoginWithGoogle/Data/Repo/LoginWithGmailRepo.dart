import 'package:video_diary/Core/networking/ApiServices.dart';

class LoginWithGmailRepo {
  final ApiServices apiServices;

  LoginWithGmailRepo({required this.apiServices});

  Future loginWithGoogleRep() async {
    await apiServices.loginWithGoogle();
  }
}
