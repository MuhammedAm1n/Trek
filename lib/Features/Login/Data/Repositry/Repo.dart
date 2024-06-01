import 'package:video_diary/Core/networking/ApiServices.dart';

class LoginRepo {
  final ApiServices apiServices;

  LoginRepo({required this.apiServices});

  Future LoginRep(String email, String password) async {
    await apiServices.logiN(email, password);
  }
}
