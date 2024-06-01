import 'package:video_diary/Core/networking/ApiServices.dart';

class RegisterRepo {
  final ApiServices apiServices;

  RegisterRepo({required this.apiServices});

  Future registerRep(String email, String password) async {
    await apiServices.registeR(email, password);
  }

  Future createUserRep(String userName) async {
    await apiServices.createUser(userName);
  }
}
