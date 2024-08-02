import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoPlayer.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

class FavoriteCard extends StatelessWidget {
  final MoodModel diary;
  final void Function()? onPressed;

  const FavoriteCard({super.key, required this.onPressed, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: ColorsApp.lightGrey,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Stack(
            children: [
              // Video Thumbnail
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Videoplayerz(Path: diary.path)),
                  );
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorsApp.lightGrey,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: FileImage(File(diary
                          .thumb)), // Replace with your video thumbnail URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Play Button Overlay
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(color: ColorsApp.lightGrey),
            child: SizedBox(
                height:
                    45, // Set a fixed height for the container holding the text

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        diary.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: onPressed,
                        child: Icon(
                          !diary.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: ColorsApp.mainColor,
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ]));
  }
}
