// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/DropDownButton.dart';
import 'package:video_diary/Features/HomePage/Widgets/TimeBar.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoCard.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/UserPage/Logic/cubit/user_details_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> moodFilter = ["Great", "Well", "Fine", "Bad", "Terrible"];
  List<String> selectedMood = [];
  bool isFilterVisible = false;
  @override
  void initState() {
    context.read<MoodCubit>().emitGetMood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.MoodSelect);
        },
        backgroundColor: ColorsApp.mainOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Entries',
          style: TextStyle(
              color: ColorsApp.mainOrange,
              fontSize: 26,
              fontWeight: FontWeight.w400),
        ),
        backgroundColor: ColorsApp.Navigationbar,
        actions: [
          BlocProvider(
            create: (context) => getIT<UserDetailsCubit>(),
            child: DropDown(),
          ),
        ],
      ),
      body: Container(
        color: Colors.white12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimeBar(),
            SizedBox(
              height: 50,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Visibility(
                  visible: isFilterVisible,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: moodFilter
                          .map((mood) => Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: FilterChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  selectedColor: Colors.white12,
                                  labelStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  backgroundColor: ColorsApp.mainOrange,
                                  selected: selectedMood.contains(mood),
                                  label: Text(mood),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedMood.add(mood);
                                      } else {
                                        selectedMood.remove(mood);
                                      }
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: ColorsApp.darkGrey,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Datetime(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFilterVisible = !isFilterVisible;
                                });
                              },
                              child: Icon(
                                Icons.filter_list_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      listVeiw()
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Datetime() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Good Morning",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Morning.json', height: 30, width: 30),
        ],
      );
    } else if (hour >= 12 && hour < 17) {
      return Row(
        children: [
          Text("Good Afternoon",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Afternon.json', height: 30, width: 30)
        ],
      );
    } else {
      return Row(
        children: [
          Text("Good Evening",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/night.json', height: 30, width: 30)
        ],
      );
    }
  }

  listVeiw() {
    return Expanded(child: BlocBuilder<MoodCubit, MoodState>(
        builder: (BuildContext context, state) {
      if (state is GetMoodSuccess) {
        final listVeiwmood = state.moods.where((mood) {
          return selectedMood.isEmpty || selectedMood.contains(mood.label);
        }).toList();
        if (listVeiwmood.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Diaries Added Yet!',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return ListView(children: [
            ListView.builder(
              itemCount: listVeiwmood.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final reversedList = listVeiwmood.reversed.toList()[i];
                return VideoCard(
                    moodMap: reversedList,
                    deletTap: (p0) {
                      setState(() {
                        return context
                            .read<MoodCubit>()
                            .emitDeleteMood(reversedList.id!);
                      });

                      context.read<MoodCubit>().emitGetMood();
                    });
              },
            ),
          ]);
        }
      } else if (state is GetMoodLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Text("");
      }
    }));
  }
}
