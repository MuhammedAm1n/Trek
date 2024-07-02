import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/DiaryApp.dart';

class ApiNotification {
// create instance of firebase messaging
  final _notifications = FirebaseMessaging.instance;

  //fun to initalize Notification

  Future<void> initNotification() async {
    // reqest from user to give permission
    await _notifications.requestPermission();
    //fetch the fc token for this device

    initPushNotification();
  }

  void handleMessages(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(Routes.MoodSelect, arguments: message);
  }

  //background service setting

  Future initPushNotification() async {
    // if the app termenited and now opend
    _notifications.getInitialMessage().then(handleMessages);
//attach event listeners for when a notifications  opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }
}
