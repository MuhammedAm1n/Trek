import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_diary/Core/networking/ApiServices.dart';

class Remindersrepo {
  final ApiServices _apiServices;

  Remindersrepo({required ApiServices apiServices})
      : _apiServices = apiServices;

  void addReminder(String massage) {
    _apiServices.AddReminder(massage);
  }

  Stream<QuerySnapshot<Object?>> getReminder() {
    return _apiServices.getRemindersStream();
  }
}
