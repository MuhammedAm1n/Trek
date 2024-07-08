import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
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

  Widget reasonSelect(
      BuildContext context, String name, IconData icon, int whyIndex) {
    return InkWell(
        splashColor: Colors.white,
        onTap: () {
          setState(() {
            _whyList[whyIndex] = _whyList[whyIndex] == 0 ? 1 : 0;
          });
        },
        child: Container(
            decoration: const BoxDecoration(
              color: ColorsApp.mainOrange,
            ),
            margin: const EdgeInsets.all(3.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: (MediaQuery.of(context).size.width - 60) / 5 - 30,
                    color: _whyList[whyIndex] == 0
                        ? ColorsApp.darkGrey
                        : Colors.white,
                  ),
                  Text(name,
                      style: TextStyle(
                        color: _whyList[whyIndex] == 0
                            ? ColorsApp.darkGrey
                            : Colors.white,
                      ))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoodCubit, MoodState>(
      listener: (context, state) {
        if (state is InsertMoodSuccess) {
          context.read<MoodCubit>().emitGetMood();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: ColorsApp.darkGrey),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 60.h,
                automaticallyImplyLeading: false, // Appbar return to back
                pinned: true,
                backgroundColor: ColorsApp.Navigationbar,

                actions: [
                  const Text(
                    'Skip Diary Today',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, Routes.BottomNavigatorHome);
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        weight: 20,
                      ))
                ],

                excludeHeaderSemantics: false,
                flexibleSpace: const FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topRight,
                            colors: <Color>[
                              ColorsApp.darkGrey,
                              ColorsApp.mainOrange,
                              ColorsApp.darkGrey,
                              ColorsApp.darkGrey,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Colors.white),
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
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  if (moodVal >= 1 && moodVal < 3)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/Great.json', height: 100),
                        const SizedBox(height: 10),
                        const Text("Pretty well",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  if (moodVal >= -1 && moodVal < 1)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/Fine.json', height: 100),
                        const SizedBox(height: 10),
                        const Text("Completely Fine",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  if (moodVal >= -3 && moodVal < -1)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/SomeThingBad.json',
                            height: 100),
                        const SizedBox(height: 10),
                        const Text("Somewhat Bad",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  if (moodVal < -3)
                    Column(
                      children: <Widget>[
                        Lottie.asset('assets/emotions/TotalyTerrible.json',
                            height: 100),
                        const SizedBox(height: 10),
                        const Text("Totally Terrible",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  Slider(
                    activeColor: Colors.white,
                    inactiveColor: ColorsApp.mainOrange,
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
                        fontSize: 24,
                        color: Colors.white),
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
                    reasonSelect(context, "family", OMIcons.home, 0),
                    reasonSelect(context, "friends", OMIcons.peopleOutline, 1),
                    reasonSelect(context, "work", Icons.business, 2),
                    reasonSelect(context, "hobbies", Icons.gesture, 3),
                    reasonSelect(context, "school", OMIcons.school, 4),
                    reasonSelect(context, "love", Icons.favorite_border, 5),
                    reasonSelect(context, "health", Icons.healing, 6),
                    reasonSelect(context, "music", OMIcons.headset, 7),
                    reasonSelect(context, "food", OMIcons.kitchen, 8),
                    reasonSelect(context, "news", OMIcons.announcement, 9),
                    reasonSelect(context, "weather", OMIcons.wbSunny, 10),
                    reasonSelect(context, "money", OMIcons.localAtm, 11),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        String videopath =
                            await _RecordVideo(ImageSource.camera, context);
                        String thumbnail =
                            await generateAndSaveThumbnail(videopath);
                        String moodLabel = getMoodLabel(moodVal);
                        context.read<MoodCubit>().emitInsertMood(MoodModel(
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
                            color: ColorsApp.darkGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ])),
              )
            ],
          ),
        ),
      ),
    );
  }

  _RecordVideo(ImageSource img, BuildContext context) async {
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
        print('Error saving video: $e');
        return null;
      }
    } else {
      print('Video not saved');
      return null;
    }
  }

  generateAndSaveThumbnail(String videoPath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 128,
      maxWidth: 80,
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
    } else if (thumbnailPath == null) {
      return print(thumbnailPath);
    }
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
