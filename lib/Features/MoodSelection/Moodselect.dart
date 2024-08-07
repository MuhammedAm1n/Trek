import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicons/unicons.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/CustomSnackbar.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/location_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class MoodSelect extends StatefulWidget {
  const MoodSelect({super.key});

  @override
  State<MoodSelect> createState() => _MoodSelectState();
}

class _MoodSelectState extends State<MoodSelect> {
  final List<int> _whyList = List.filled(12, 0,
      growable:
          false); //0 = family, 1= friends, 2=work, 3=hobbies, 4=school,5=relationships,6=sleep,7=travelling,8=food,9=health,10music,11=relaxing
  double moodVal = 0;
  DateTime dateTime = DateTime.now().add(const Duration(days: 0));
  ImageSource? img;

  String location = '';

  Widget reasonSelect(
      BuildContext context, String name, IconData icon, int whyIndex) {
    bool isSelected = _whyList[whyIndex] == 1;

    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        setState(() {
          _whyList[whyIndex] = isSelected ? 0 : 1;
        });
      },
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: isSelected ? 1.0 : 0.6,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 7,
                  offset: const Offset(2, 2),
                ),
              ],
              color: ColorsApp.backGround,
            ),
            margin: const EdgeInsets.all(3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: (MediaQuery.of(context).size.width - 60) / 5 - 30,
                  color:
                      isSelected ? ColorsApp.mainColor : ColorsApp.secLightGrey,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color:
                        isSelected ? ColorsApp.mainColor : ColorsApp.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoodCubit, MoodState>(
      listener: (context, state) {
        if (state is InsertMoodSuccess) {
          context.read<MoodCubit>().loadMood();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: ColorsApp.backGround),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 60.h,
                automaticallyImplyLeading: false, // Appbar return to back
                pinned: true,
                backgroundColor: ColorsApp.backGround,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 7),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "assets/images/arrow8.png",
                      scale: 30,
                    ),
                  ),
                ),

                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0, top: 7),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return BlocProvider(
                              create: (context) => getIT<LocationCubit>(),
                              child: BlocConsumer<LocationCubit, LocationState>(
                                listener: (context, state) {
                                  if (state is LocationSucess) {
                                    Navigator.pop(
                                        context); // Close the dialog when location is loaded

                                    CustomSnackbar.showSnackbar(
                                        context, 'Location: ${state.Location}');

                                    location = state.Location;
                                  } else if (state is LocationFaliuer) {
                                    CustomSnackbar.showSnackbar(
                                        context, 'Error: ${state.message}');
                                  }
                                },
                                builder: (context, state) {
                                  return AlertDialog(
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    icon: const Icon(
                                      Icons.pin_drop,
                                      color: ColorsApp.mainColor,
                                      size: 32,
                                    ),
                                    content: state is LocationLoading
                                        ? const LinearProgressIndicator(
                                            color: ColorsApp.mainColor,
                                          )
                                        : const Text(
                                            "Catch Location up",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          context
                                              .read<LocationCubit>()
                                              .emitGetLocation();
                                        },
                                        child: const Text(
                                          'Got it',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: Image.asset(
                        "assets/images/map1.png",
                        scale: 22,
                      ),
                    ),
                  ),
                ],

                excludeHeaderSemantics: false,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (moodVal >= 3)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/SuperGreat.json',
                            height: 100),
                        const SizedBox(height: 10),
                        const Text("Super Great",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  if (moodVal >= 1 && moodVal < 3)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/Great.json', height: 100),
                        const SizedBox(height: 10),
                        const Text("Pretty well",
                            style: TextStyle(
                              color: Colors.black,
                            ))
                      ],
                    ),
                  if (moodVal >= -1 && moodVal < 1)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/Fine.json', height: 100),
                        const SizedBox(height: 10),
                        const Text("Completely Fine",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  if (moodVal >= -3 && moodVal < -1)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/SomeThingBad.json',
                            height: 100),
                        const SizedBox(height: 10),
                        const Text("Somewhat Bad",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  if (moodVal < -3)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/TotalyTerrible.json',
                            height: 100),
                        const SizedBox(height: 10),
                        const Text("Totally Terrible",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  Slider(
                    activeColor: ColorsApp.mediumGrey,
                    inactiveColor: Colors.grey.shade300,
                    min: -5.0,
                    max: 5.0,
                    value: moodVal,
                    onChanged: (value) {
                      setState(() {
                        moodVal = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Why do you feel this way?',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ])),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                sliver: SliverGrid.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: <Widget>[
                    reasonSelect(context, "family", UniconsLine.home, 0),
                    reasonSelect(context, "friends", OMIcons.peopleOutline, 1),
                    reasonSelect(context, "work", Icons.business, 2),
                    reasonSelect(context, "hobbies", Icons.gesture, 3),
                    reasonSelect(context, "school", OMIcons.school, 4),
                    reasonSelect(context, "love", UniconsLine.heart, 5),
                    reasonSelect(context, "health", Icons.healing, 6),
                    reasonSelect(context, "music", OMIcons.headset, 7),
                    reasonSelect(context, "food", OMIcons.kitchen, 8),
                    reasonSelect(context, "news", UniconsLine.newspaper, 9),
                    reasonSelect(context, "weather", OMIcons.wbSunny, 10),
                    reasonSelect(context, "money", OMIcons.localAtm, 11),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 140, // Set the desired width
                          height: 40, // Set the desired height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsApp.lightGrey,
                                elevation: 5, // Add shadow
                                shadowColor:
                                    Colors.grey // Set shadow color if needed
                                ),
                            onPressed: () async {
                              String videopath = await _recordVideo(
                                  ImageSource.camera, context);
                              String thumbnail =
                                  await generateAndSaveThumbnail(videopath);
                              String moodLabel = getMoodLabel(moodVal);
                              context.read<MoodCubit>().insertMood(MoodModel(
                                  location: location,
                                  mood: moodVal,
                                  path: videopath,
                                  date: dateTime,
                                  why: _whyList,
                                  thumb: thumbnail,
                                  label: moodLabel));

                              Navigator.pushNamed(
                                  context, Routes.BottomNavigatorHome);
                            },
                            child: const Text(
                              "Record Video",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _recordVideo(ImageSource img, BuildContext context) async {
    final XFile? videoFile = await ImagePicker()
        .pickVideo(source: img, maxDuration: const Duration(seconds: 20));
    if (videoFile != null) {
      try {
        // Save video to an app-specific directory
        final appDir = await getApplicationDocumentsDirectory();
        final hiddenDir = Directory('${appDir.path}/.myAppVideos');
        if (!(await hiddenDir.exists())) {
          await hiddenDir.create(recursive: true);
          // Create a .nomedia file to prevent media scanning
          File('${hiddenDir.path}/.nomedia').createSync();
        }

        // Move the video file to the hidden directory
        final File newFile = await File(videoFile.path)
            .copy('${hiddenDir.path}/${videoFile.name}');

        await generateAndSaveThumbnail(newFile.path);
        return newFile.path;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  generateAndSaveThumbnail(String videoPath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 420,
      maxWidth: 380,
      quality: 100,
    );

    if (thumbnailPath != null) {
      // Move the thumbnail to the app-specific directory
      final appDir = await getApplicationDocumentsDirectory();
      final hiddenDir = Directory('${appDir.path}/.myAppThumbnails');
      if (!(await hiddenDir.exists())) {
        await hiddenDir.create(recursive: true);
        // Create a .nomedia file to prevent media scanning
        File('${hiddenDir.path}/.nomedia').createSync();
      }

      final File thumbnailFile = await File(thumbnailPath).copy(
          '${hiddenDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      return thumbnailFile.path;
    } else if (thumbnailPath == null) {}
  }

  String getMoodLabel(double moodVal) {
    if (moodVal >= 3) {
      return "Great";
    } else if (moodVal >= 1 && moodVal < 3) {
      return "Well";
    } else if (moodVal >= -1 && moodVal < 1) {
      return "Fine";
    } else if (moodVal >= -3 && moodVal < -1) {
      return "Bad";
    } else if (moodVal < -3) {
      return "Terrible";
    } else {
      return "Bad";
    }
  }
}
