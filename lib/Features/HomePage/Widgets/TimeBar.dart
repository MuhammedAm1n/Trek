import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class TimeBar extends StatelessWidget {
  const TimeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(
                    DateTime.now(),
                  ),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Text(
                  'Today',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.mainOrange),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
