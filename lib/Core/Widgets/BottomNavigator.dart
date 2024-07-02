import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Analysis/AnalysisPage.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/Todo/Todo.dart';
import 'package:video_diary/Features/HomePage/homeScreen.dart';

class BottomNavigatorHome extends StatefulWidget {
  const BottomNavigatorHome({super.key});

  @override
  State<BottomNavigatorHome> createState() => _BottomNavigatorHomeState();
}

class _BottomNavigatorHomeState extends State<BottomNavigatorHome> {
  int index = 0;
  late PageController _pageController;

  final page = [
    BlocProvider(
      create: (context) => getIT<MoodCubit>(),
      child: const HomeScreen(),
    ),
    BlocProvider(
      create: (context) => getIT<MoodCubit>(),
      child: const AnalysisPage(),
    ),
    const ProgressTodo(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onItemTapped(int index) {
    this.index = index;
    _pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          this.index = index;
        },
        children: page,
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: index,
          onTap: _onItemTapped,
          backgroundColor: ColorsApp.darkGrey,
          color: ColorsApp.Navigationbar,
          animationDuration: const Duration(milliseconds: 300),
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
