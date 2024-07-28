// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:share_plus/share_plus.dart';
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
  // final GoogleDriveApi _googleDriveApi = GoogleDriveApi();
  @override
  void initState() {
    super.initState();

    context.read<MoodCubit>().loadMood();
  }

  // Future<void> _authenticateGoogleDrive() async {
  //   await _googleDriveApi.authenticate();
  // }

  // Future<void> _uploadVideo(String filePath) async {
  //   final fileName = path.basename(filePath);
  //   await _googleDriveApi.uploadFile(filePath, fileName);
  //   CustomSnackbar.showSnackbar(context, '$fileName uploaded to Google Drive');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backGround,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.MoodSelect);
        },
        backgroundColor: ColorsApp.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.ReminderPage);
          },
          child: Icon(
            Icons.format_quote_sharp,
            color: ColorsApp.mediumGrey,
            size: 35,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: BlocProvider(
              create: (context) => getIT<UserDetailsCubit>(),
              child: DropDown(),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          TimeBar(),
          SizedBox(
            height: 40,
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
                                side: BorderSide(
                                    color: selectedMood.contains(mood)
                                        ? ColorsApp.mainColor
                                        : Colors.black,
                                    width: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                selectedColor: ColorsApp.mainColor,
                                labelStyle: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                  color: ColorsApp.backGround,
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
                          datetime(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFilterVisible = !isFilterVisible;
                              });
                            },
                            child: Icon(
                              Icons.filter_list_rounded,
                              color: Colors.black,
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
    );
  }

  datetime() {
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
                  color: Colors.black)),
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
                  color: Colors.black)),
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
                  color: Colors.black)),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Lottie.asset('assets/emotions/NewMoon.json',
                height: 30, width: 30),
          )
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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: VideoCard(
                      onUpload: () async {
                        final result = await Share.shareXFiles(
                            [XFile(reversedList.path)],
                            text: 'Great picture');

                        if (result.status == ShareResultStatus.success) {
                          print('Thank you for sharing the picture!');
                        }
                      },
                      moodMap: reversedList,
                      deletTap: (p0) {
                        setState(() {
                          return context
                              .read<MoodCubit>()
                              .deleteMood(reversedList.id!);
                        });

                        context.read<MoodCubit>().loadMood();
                      }),
                );
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
