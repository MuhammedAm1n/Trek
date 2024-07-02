import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoPlayer.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.moodMap, this.deletTap});

  final MoodModel moodMap;
  final void Function(BuildContext)? deletTap;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  Widget reasonTile(BuildContext context, IconData icon) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2.0, color: ColorsApp.mainOrange),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        width: 42.0,
        height: 42.0,
        margin: const EdgeInsets.all(2.0),
        //padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
                color: Colors.black,
              ),
            ]));
  }

  // Uint8List? thumbnail;

  // @override
  // initState() {
  //   super.initState();
  //   genThumbnail();
  // }

  // Future<void> genThumbnail() async {
  //   thumbnail = await VideoThumbnail.thumbnailData(
  //       video: widget.moodMap.path,
  //       imageFormat: ImageFormat.JPEG,
  //       maxWidth: 128,
  //       quality: 50);

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    double moodVal = widget.moodMap.mood;
    String thumB = widget.moodMap.thumb;
    String phrase = "";
    String Videopath = widget.moodMap.path;
    // String delete;

    List<int> reasonList = [
      widget.moodMap.why[0],
      widget.moodMap.why[1],
      widget.moodMap.why[2],
      widget.moodMap.why[3],
      widget.moodMap.why[4],
      widget.moodMap.why[5],
      widget.moodMap.why[6],
      widget.moodMap.why[7],
      widget.moodMap.why[8],
      widget.moodMap.why[9],
      widget.moodMap.why[10],
      widget.moodMap.why[11],
    ];
    var list = [for (var i = 0; i < 12; i += 1) i];

    List<Widget> reasonTiles = [
      reasonTile(context, OMIcons.home),
      reasonTile(context, OMIcons.peopleOutline),
      reasonTile(context, Icons.business),
      reasonTile(context, Icons.gesture),
      reasonTile(context, OMIcons.school),
      reasonTile(context, Icons.healing),
      reasonTile(context, Icons.healing),
      reasonTile(context, OMIcons.headset),
      reasonTile(context, OMIcons.kitchen),
      reasonTile(context, OMIcons.announcement),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Videoplayerz(Path: Videopath)),
        );
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deletTap,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          color: ColorsApp.darkGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(
                      File(thumB),
                      scale: 1.2,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(phrase,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 15),
                            Wrap(children: [
                              for (int i in list)
                                if (reasonList[i] == 1) reasonTiles[i]
                            ])
                          ]),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, left: 13),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ColorsApp.mainOrange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                            "${DateFormat.yMMMMd().format(DateTime.parse(widget.moodMap.date.toString()))} ",
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < 70; i++)
                          i.isEven
                              ? Container(
                                  width: 3,
                                  height: 1,
                                  decoration: BoxDecoration(
                                      color: ColorsApp.mainOrange,
                                      borderRadius: BorderRadius.circular(2)),
                                )
                              : Container(
                                  height: 1,
                                  width: 3,
                                  color: ColorsApp.mainOrange,
                                )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
