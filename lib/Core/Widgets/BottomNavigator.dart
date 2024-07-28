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
    setState(() {
      this.index = index;
      _pageController.jumpToPage(
        index,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        children: page,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: ColorsApp.lightGrey))),
          child: BottomNavigationBar(
              elevation: 0,
              selectedItemColor: ColorsApp.mainColor,
              backgroundColor: Colors.white,
              currentIndex: index,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.analytics_sharp,
                      size: 30,
                    ),
                    label: "Stats"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.task_alt_rounded,
                      size: 30,
                    ),
                    label: "Tasks")
              ]),
        ),
      ),
    );

    //  CurvedNavigationBar(
    //       index: index,
    //       onTap: _onItemTapped,
    //       backgroundColor: ColorsApp.backGround,
    //       color: Colors.black,
    //       animationDuration: const Duration(milliseconds: 300),
    //       items: const [
    //         Icon(
    //           Icons.home,
    //           color: Colors.white,
    //         ),
    //         Icon(
    //           Icons.analytics_sharp,
    //           color: Colors.white,
    //         ),
    //         Icon(
    //           Icons.task_alt_rounded,
    //           color: Colors.white,
    //         ),
    //       ]),
  }
}
