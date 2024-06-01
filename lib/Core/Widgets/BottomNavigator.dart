import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Analysis/AnalysisPage.dart';
import 'package:video_diary/Features/Todo/Todo.dart';
import 'package:video_diary/Features/HomePage/homeScreen.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

import '../Di/dependency.dart';

class BottomNavigatorHome extends StatefulWidget {
  BottomNavigatorHome({super.key});

  @override
  State<BottomNavigatorHome> createState() => _BottomNavigatorHomeState();
}

class _BottomNavigatorHomeState extends State<BottomNavigatorHome> {
  int index = 0;
  final page = [
    BlocProvider(
      create: (context) => getIT<MoodCubit>(),
      child: HomeScreen(),
    ),
    BlocProvider(
      create: (context) => getIT<MoodCubit>(),
      child: AnalysisPage(),
    ),
    ProgressTodo()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: page,
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: index,
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
          backgroundColor: ColorsApp.darkGrey,
          color: ColorsApp.Navigationbar,
          animationDuration: Duration(milliseconds: 300),
          items: const [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.analytics_sharp,
              color: Colors.white,
            ),
            Icon(
              Icons.message,
              color: Colors.white,
            ),
          ]),
    );
  }
}
