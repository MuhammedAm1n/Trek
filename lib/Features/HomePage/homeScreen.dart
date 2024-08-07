import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/CustomSnackbar.dart';
import 'package:video_diary/Core/Widgets/SearchBar.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/DropDownButton.dart';
import 'package:video_diary/Features/HomePage/Widgets/TimeBar.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoCard.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
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
  List<MoodModel> _moodList = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    context.read<MoodCubit>().loadMood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(101, 245, 245, 245),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, Routes.MoodSelect);
        },
        backgroundColor: ColorsApp.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: ColorsApp.backGround,
        backgroundColor: ColorsApp.backGround,
        shadowColor: ColorsApp.mediumGrey,
        elevation: 1,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          "assets/images/NEW.png",
          scale: 22,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.ReminderPage);
          },
          icon: const Icon(
            Icons.format_quote_sharp,
            color: Colors.black87,
            size: 28,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocProvider(
              create: (context) => getIT<UserDetailsCubit>(),
              child: const DropDown(),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              children: [
                const TimeBar(),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 14),
                  child: SearchBarHome(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final horizontalPadding = screenWidth * 0.03;
                final chipPadding = screenWidth * 0.03;

                return Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: Visibility(
                    visible: isFilterVisible,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: moodFilter
                            .map((mood) => Padding(
                                  padding: EdgeInsets.only(right: chipPadding),
                                  child: FilterChip(
                                    side: BorderSide(
                                        color: selectedMood.contains(mood)
                                            ? ColorsApp.mainColor
                                            : ColorsApp.secLightGrey,
                                        width: 0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    selectedColor: ColorsApp.mainColor,
                                    labelStyle: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w500),
                                    backgroundColor: Colors.white,
                                    selected: selectedMood.contains(mood),
                                    label: Text(mood),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedMood.add(mood);
                                        } else {
                                          selectedMood.remove(mood);
                                        }
                                        // Trigger mood load after selection change
                                        context.read<MoodCubit>().loadMood();
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
                color: ColorsApp.backGround,
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(70)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        datetime(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isFilterVisible = !isFilterVisible;
                            });
                          },
                          icon: const Icon(
                            Icons.filter_list_rounded,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: listView(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget datetime() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Good Morning",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Morning.json', height: 30, width: 30),
        ],
      );
    } else if (hour >= 12 && hour < 17) {
      return Row(
        children: [
          const Text("Good Afternoon",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Afternon.json', height: 30, width: 30),
        ],
      );
    } else {
      return Row(
        children: [
          const Text("Good Evening",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Lottie.asset('assets/emotions/NewMoon.json',
                height: 30, width: 30),
          ),
        ],
      );
    }
  }

  Widget listView() {
    return BlocConsumer<MoodCubit, MoodState>(
      listener: (context, state) {
        if (state is GetMoodFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is GetMoodSuccess) {
          setState(() {
            _moodList = state.moods.where((mood) {
              return selectedMood.isEmpty || selectedMood.contains(mood.label);
            }).toList();
          });
        }
      },
      builder: (context, state) {
        if (state is GetMoodLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_moodList.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Image.asset(
                      "assets/animations/Home.png",
                      scale: 5.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is GetMoodSuccess || _moodList.isNotEmpty) {
          return ListView.builder(
            key: _listKey,
            itemCount: _moodList.length,
            itemBuilder: (context, index) {
              final moodItem = _moodList.reversed.toList()[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: VideoCard(
                  onUpload: () async {
                    await Share.shareXFiles(
                      [XFile(moodItem.path)],
                      text: 'Great Video',
                    );
                  },
                  moodMap: moodItem,
                  deletTap: (d) {
                    deleteMood(index);
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text('Unexpected state'));
      },
    );
  }

  Future<void> deleteMood(int displayIndex) async {
    try {
      // Reverse the list to get the actual index in the original list
      final originalIndex = _moodList.length - 1 - displayIndex;

      // Get the mood item based on the calculated original index
      final moodToDelete = _moodList[originalIndex];

      // Delete the video file associated with the mood
      final filePath = moodToDelete.path;
      final file = File(filePath);
      await file.delete();

      // Delete the mood item from the data source (e.g., server, database)
      await context.read<MoodCubit>().deleteMood(moodToDelete.id!);

      // Update the state to reflect the deletion
      setState(() {
        _moodList
            .removeAt(originalIndex); // Remove the item from the original list
      });
    } catch (e) {
      CustomSnackbar.showSnackbar(context, "Failed to delete video");
    }
  }
}
