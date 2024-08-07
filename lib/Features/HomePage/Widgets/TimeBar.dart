import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:video_diary/Core/Di/dependency.dart';

import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class TimeBar extends StatefulWidget {
  const TimeBar({super.key});

  @override
  State<TimeBar> createState() => _TimeBarState();
}

class _TimeBarState extends State<TimeBar> {
  final MoodCubit moodCubit = getIT<MoodCubit>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          DateFormat.yMMMMd().format(DateTime.now()),
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }
}
