import 'package:flutter/material.dart';
import 'package:video_diary/Core/Di/dependency.dart';

import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/CustomSearch.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final moodcubit = getIT<MoodCubit>();

    return Container(
      width: screenWidth * 0.63, // Use a fraction of the screen width
      height: screenHeight * 0.060, // Use a fraction of the screen height
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            spreadRadius: 0.3,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
        color: ColorsApp.backGround,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: ColorsApp.backGround,
              keyboardType: TextInputType.none,
              onTap: () async {
                // Navigator.pushNamed(context, Routes.SearchPage).then((value) {
                //   if (value == true) {
                //     updateParentState("Heloooo");
                //   }
                // });

                await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(moodCubit: moodcubit),
                );
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: ColorsApp.secLightGrey,
                ),
                hintText: ' Search for video.', // Remove extra spaces
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
