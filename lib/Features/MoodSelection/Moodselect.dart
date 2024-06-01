import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:folder_file_saver/folder_file_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

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
        splashColor: ColorsApp.mainOrange,
        onTap: () {
          setState(() {
            _whyList[whyIndex] = _whyList[whyIndex] == 0 ? 1 : 0;
          });
        },
        child: Container(
            decoration: BoxDecoration(
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
                        ? Theme.of(context).cardTheme.color
                        : Colors.white,
                  ),
                  Text(name,
                      style: TextStyle(
                        color: _whyList[whyIndex] == 0
                            ? Theme.of(context).cardTheme.color
                            : Colors.white,
                      ))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 100.h,
              automaticallyImplyLeading: false, // Appbar return to back
              pinned: true,
              backgroundColor: ColorsApp.darkGrey,

              actions: [
                const Text(
                  'Skip Diary Today',
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.white),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.BottomNavigatorHome);
                    },
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                    ))
              ],

              excludeHeaderSemantics: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  //height: 279,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: <Widget>[
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: <Color>[
                              Color(0xFF202020),
                              Color(0xFF383838),
                            ],
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: <Color>[
                              Color(0xB2000000),
                              Color(0x00000000),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/emotions/ssz.png',
                        height: 2,
                        fit: BoxFit.cover,
                        color: ColorsApp.mainOrange,
                        colorBlendMode: BlendMode.multiply,
                      ),
                    ],
                  ),
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
                const SizedBox(height: 10),
                if (moodVal >= 3)
                  Column(
                    children: <Widget>[
                      Image.asset('assets/emotions/emotion4.png', height: 75),
                      const SizedBox(height: 10),
                      const Text("Super Great",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                if (moodVal >= 1 && moodVal < 3)
                  Column(
                    children: <Widget>[
                      Image.asset('assets/emotions/emotion3.png', height: 75),
                      const SizedBox(height: 10),
                      const Text("Pretty well",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                if (moodVal >= -1 && moodVal < 1)
                  Column(
                    children: <Widget>[
                      Image.asset('assets/emotions/emotion2.png', height: 75),
                      const SizedBox(height: 10),
                      const Text("Completely Fine",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                if (moodVal >= -3 && moodVal < -1)
                  Column(
                    children: <Widget>[
                      Image.asset('assets/emotions/emotion1.png', height: 75),
                      const SizedBox(height: 10),
                      const Text("Somewhat Bad",
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                if (moodVal < -3)
                  Column(
                    children: <Widget>[
                      Image.asset('assets/emotions/emotion0.png', height: 75),
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
                const Divider(
                  color: Colors.black,
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
                      context.read<MoodCubit>().emitInsertMood(MoodModel(
                          mood: moodVal,
                          path: await _RecordVideo(ImageSource.camera, context),
                          date: dateTime,
                          why: _whyList));

                      Navigator.pushNamed(context, Routes.BottomNavigatorHome);
                    },
                    child: const Text("Record Video"),
                  ),
                ),
              ])),
            )
          ],
        ),
      ),
    );
  }

  _RecordVideo(ImageSource img, BuildContext context) async {
    final XFile? videoFile = await ImagePicker().pickVideo(source: img);

    if (videoFile != null) {
      var path = await FolderFileSaver.saveFileIntoCustomDir(
          filePath: videoFile.path, dirNamed: 'DiaryV');
      return path;
    } else {
      print('dontsaved');
    }
  }
}
