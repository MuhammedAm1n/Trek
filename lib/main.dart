import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_diary/Core/Di/dependency.dart';

import 'package:video_diary/Core/networking/ApiNotification.dart';
import 'package:video_diary/Core/routing/routingmanger.dart';
import 'package:video_diary/DiaryApp.dart';
import 'package:video_diary/firebase_options.dart';

void main() async {
  setUpGit();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ApiNotification().initNotification();

  runApp(DiaryApp(
    routesManager: RoutesManager(),
  ));
}
