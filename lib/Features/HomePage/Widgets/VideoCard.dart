import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:unicons/unicons.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoPlayer.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.moodMap,
    this.deletTap,
    this.onUpload,
  });

  final void Function()? onUpload;
  final MoodModel moodMap;
  final void Function(BuildContext)? deletTap;

  Widget reasonTile(BuildContext context, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tileSize = screenWidth * 0.1; // Responsive tile size

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 2.0, color: ColorsApp.mainColor),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      width: tileSize,
      height: tileSize,
      margin: const EdgeInsets.all(2.0),
      child: Center(
        child: Icon(
          icon,
          size: tileSize * 0.6, // Icon size relative to tile size
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.3; // Responsive width
    final double imageHeight = imageWidth * 1.6; // Aspect ratio

    double moodVal = moodMap.mood;
    String thumB = moodMap.thumb;
    String phrase = "";
    String videopath = moodMap.path;

    List<int> reasonList = [
      moodMap.why[0],
      moodMap.why[1],
      moodMap.why[2],
      moodMap.why[3],
      moodMap.why[4],
      moodMap.why[5],
      moodMap.why[6],
      moodMap.why[7],
      moodMap.why[8],
      moodMap.why[9],
      moodMap.why[10],
      moodMap.why[11],
    ];

    var list = [for (var i = 0; i < 12; i += 1) i];

    List<Widget> reasonTiles = [
      reasonTile(context, UniconsLine.home),
      reasonTile(context, OMIcons.peopleOutline),
      reasonTile(context, Icons.business),
      reasonTile(context, Icons.gesture),
      reasonTile(context, OMIcons.school),
      reasonTile(context, UniconsLine.heart),
      reasonTile(context, Icons.healing),
      reasonTile(context, OMIcons.headset),
      reasonTile(context, OMIcons.kitchen),
      reasonTile(context, UniconsLine.newspaper),
      reasonTile(context, OMIcons.wbSunny),
      reasonTile(context, OMIcons.localAtm),
    ];

    if (moodVal >= 3) {
      phrase = "Super Great";
    } else if (moodVal >= 1) {
      phrase = "Pretty well";
    } else if (moodVal >= -1) {
      phrase = "Completely Fine";
    } else if (moodVal >= -3) {
      phrase = "Somewhat Bad";
    } else {
      phrase = "Totally Terrible";
    }

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deletTap,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
      child: Container(
        color: ColorsApp.backGround,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Videoplayerz(Path: videopath)),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(thumB),
                        width: imageWidth * 0.8,
                        height: imageHeight * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phrase,
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: [
                            for (int i in list)
                              if (reasonList[i] == 1) reasonTiles[i],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: onUpload,
                          icon: Icon(
                            UniconsLine.share,
                            size: screenWidth * 0.07, // Responsive icon size
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Row(
                children: [
                  Text(
                    "${DateFormat.yMMMMd().format(DateTime.parse(moodMap.date.toString()))} ",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  Row(
                    children: [
                      for (int i = 0; i < 70; i++)
                        i.isEven
                            ? Container(
                                width: 3,
                                height: 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )
                            : Container(
                                height: 0.7,
                                width: 3,
                                color: Colors.black,
                              ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
