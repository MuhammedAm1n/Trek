import 'package:flutter/material.dart';

import 'package:video_diary/Core/theming/Coloring.dart';

class SearchBarHome extends StatelessWidget {
  final void Function()? onTap;

  const SearchBarHome({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 0.3,
            blurRadius: 2,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: ColorsApp.backGround,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: ColorsApp.backGround,
              cursorOpacityAnimates: true,
              keyboardType: TextInputType.none,
              onTap: onTap,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: ColorsApp.secLightGrey,
                ),
                hintText: '     Search for video.',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
    );
  }
}
