import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/BottomNavigator.dart';
import 'package:video_diary/Core/Widgets/Splashscreen.dart';
import 'package:video_diary/Core/networking/Authcheck.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Features/Favourite/FavouritePage.dart';
import 'package:video_diary/Features/SearchPage/SearchPage.dart';
import 'package:video_diary/Features/Snippets/Logic/cubit/reminder_cubit.dart';
import 'package:video_diary/Features/Snippets/Snippets.dart';

import 'package:video_diary/Features/Tasks/Task.dart';
import 'package:video_diary/Features/HomePage/homeScreen.dart';
import 'package:video_diary/Features/Login/loginScreen.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Moodselect.dart';
import 'package:video_diary/Features/UserPage/Logic/cubit/user_details_cubit.dart';
import 'package:video_diary/Features/UserPage/Profilepage.dart';
import 'package:video_diary/Features/onBoarding/onboardingscreen.dart';

class RoutesManager {
  Route generateRoute(RouteSettings route) {
    switch (route.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (x) => const OnboardingScreen());
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
                  child: const HomeScreen(),
                ));
      case Routes.BottomNavigatorHome:
        return MaterialPageRoute(builder: (x) => const BottomNavigatorHome());
      case Routes.ProgressTodo:
        return MaterialPageRoute(builder: (x) => TaskPage());
      case Routes.SplashScreen:
        return MaterialPageRoute(builder: (x) => const SplashScreen());

      case Routes.AuthCheck:
        return MaterialPageRoute(builder: (x) => const AuthCheck());
      case Routes.SearchPage:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<MoodCubit>(),
                  child: const SearchPage(),
                ));
      case Routes.ReminderPage:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<ReminderCubit>(),
                  child: const SnippetsPage(),
                ));
      case Routes.FavoritePage:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<MoodCubit>(),
                  child: const FavoritePage(),
                ));
      case Routes.ProfilePage:
        return MaterialPageRoute(
            builder: (x) => BlocProvider(
                  create: (context) => getIT<UserDetailsCubit>(),
                  child: const ProfilePage(),
                ));
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
