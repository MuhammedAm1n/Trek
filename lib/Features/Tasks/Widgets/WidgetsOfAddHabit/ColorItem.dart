import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class ColorITem extends StatelessWidget {
  const ColorITem({super.key, required this.isActive, required this.color});
  final bool isActive;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return isActive
        ? CircleAvatar(
            radius: 16,
            backgroundColor: ColorsApp.secLightGrey,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: color,
            ))
        : CircleAvatar(
            radius: 14,
            backgroundColor: color,
          );
  }
}
