import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/routing/routingmanger.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class DiaryApp extends StatelessWidget {
  final RoutesManager routesManager;
  const DiaryApp({super.key, required this.routesManager});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: BlocProvider(
        create: (context) => getIT<HabitsCubit>(),
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Diary\'s Video',
          onGenerateRoute: routesManager.generateRoute,
          initialRoute: Routes.AuthCheck,
          navigatorKey: navigatorKey,
          theme: ThemeData(
              primaryColor: ColorsApp.mainOrange,
              scaffoldBackgroundColor: ColorsApp.darkGrey),
        ),
      ),
    );
  }
}
