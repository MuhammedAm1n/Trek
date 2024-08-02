import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoPlayer.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class VideoGrid extends StatefulWidget {
  const VideoGrid({super.key, required this.moodMap});
  final MoodModel moodMap;

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  @override
  Widget build(BuildContext context) {
    String thumB = widget.moodMap.thumb;
    String phrase = widget.moodMap.location;
    String videoPath = widget.moodMap.path;
    //String Videopath = widget.moodMap.path;
    String Viddate =
        " ${widget.moodMap.date.year.toString()} / ${widget.moodMap.date.month.toString()} / ${widget.moodMap.date.day.toString()}";
    // String delete;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: !widget.moodMap.favorite
            ? ColorsApp.mediumGrey
            : ColorsApp.mainColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Videoplayerz(Path: videoPath)),
              );
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.file(
                    File(thumB),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              phrase,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: ColorsApp.backGround,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Viddate,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: ColorsApp.backGround,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.moodMap.favorite = !widget.moodMap.favorite;
                      context.read<MoodCubit>().updateMood(widget.moodMap);
                    });
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return RotationTransition(
                          turns: child.key == const ValueKey('icon1')
                              ? animation
                              : Tween(begin: 1.0, end: 0.0).animate(animation),
                          child: child);
                    },
                    child: Icon(
                      !widget.moodMap.favorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      key: ValueKey<String>(
                          widget.moodMap.favorite ? 'icon1' : 'icon2'),
                      size: 25,
                      color: ColorsApp.backGround,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
