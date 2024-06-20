import 'package:flutter/material.dart';

class ColorITem extends StatelessWidget {
  const ColorITem({super.key, required this.isActive, required this.color});
  final bool isActive;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return isActive
        ? CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
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
