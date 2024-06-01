import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/routing/routingmanger.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class DiaryApp extends StatelessWidget {
  final RoutesManager routesManager;
  const DiaryApp({super.key, required this.routesManager});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary\'s Video',
        onGenerateRoute: routesManager.generateRoute,
        initialRoute: Routes.onboarding,
        theme: ThemeData(
            primaryColor: ColorsApp.mainOrange,
            scaffoldBackgroundColor: ColorsApp.darkGrey),
      ),
    );
  }
}
