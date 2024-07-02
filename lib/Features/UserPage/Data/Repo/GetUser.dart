import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_diary/Core/networking/ApiServices.dart';

class GetUserRepo {
  final ApiServices apiServices;

  GetUserRepo({required this.apiServices});

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() async {
    return await apiServices.GetUserDetails();
  }
}