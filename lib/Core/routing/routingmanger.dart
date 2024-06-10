import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/BottomNavigator.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Features/Todo/Todo.dart';
import 'package:video_diary/Features/HomePage/homeScreen.dart';
import 'package:video_diary/Features/Login/loginScreen.dart';
import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Moodselect.dart';
import 'package:video_diary/Features/onBoarding/onboardingscreen.dart';

class RoutesManager {
  Route generateRoute(RouteSettings route) {
    switch (route.name) {
      case Routes.onboarding:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<LoginWithGoogleCubit>(),
                  child: const OnboardingScreen(),
                ));
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (x) => const LoginScreen());
      case Routes.MoodSelect:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<MoodCubit>(),
                  child: const MoodSelect(),
                ));
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<MoodCubit>(),
                  child: HomeScreen(),
                ));
      case Routes.BottomNavigatorHome:
        return MaterialPageRoute(builder: (x) => BottomNavigatorHome());
      case Routes.ProgressTodo:
        return MaterialPageRoute(builder: (x) => ProgressTodo());

      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(
                    child: Text('NO routes define'),
                  ),
                ));
    }
  }
}
