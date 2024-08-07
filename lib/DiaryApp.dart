import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/CustomSnackbar.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/routing/routingmanger.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_cubit.dart';

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
        create: (context) => getIT<TaskCubit>(),
        child: GetMaterialApp(
          scaffoldMessengerKey: CustomSnackbar.scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Diary\'s Video',
          onGenerateRoute: routesManager.generateRoute,
          initialRoute: Routes.AuthCheck,
          navigatorKey: navigatorKey,
          theme: ThemeData(
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: ColorsApp.mainColor, // Change cursor color
                selectionColor:
                    ColorsApp.mainColor.withOpacity(0.5), // Selection color
                selectionHandleColor: ColorsApp.mainColor, // Handle color
              ),
              splashColor: Colors.white, // Ripple color
              highlightColor: ColorsApp.mainColor, // Highlight color
              primaryColor: ColorsApp.mainColor,
              scaffoldBackgroundColor: ColorsApp.mainColor),
        ),
      ),
    );
  }
}
