import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/SearchBar.dart';
import 'package:video_diary/Core/Widgets/VideoFrame.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class TimeBar extends StatelessWidget {
  const TimeBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MoodCubit moodCubit = getIT<MoodCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                DateFormat.yMMMMd().format(
                  DateTime.now(),
                ),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: SearchBarHome(onTap: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(moodCubit: moodCubit),
              );
            }),
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final MoodCubit moodCubit;

  CustomSearchDelegate({required this.moodCubit});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Colors.white, // Change this to your desired color
        appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            toolbarHeight: 60,
            scrolledUnderElevation: 2 // Change this to your desired color
            ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: ColorsApp.mainColor, width: 1.5), // Color when focused
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1.5,
                color: Colors
                    .black), // Adjust this to your desired underline color
          ),
        ));
  }

  @override
  String get searchFieldLabel => 'Search by dates,places';

  @override
  InputDecorationTheme get searchFieldDecorationTheme {
    return InputDecorationTheme(
      hintStyle: const TextStyle(fontSize: 17),
      focusColor: ColorsApp.mainColor,
      hoverColor: Colors.white,
      filled: true,
      fillColor: Colors.white, // Change this to your desired color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          icon: const Icon(
            Icons.clear,
            size: 25,
          ),
          onPressed: () {
            query = '';
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      color: Colors.white,
      child: IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    moodCubit.loadMood();
    List<MoodModel> matchQuery = [];

    for (var video in moodCubit.moods) {
      // Check for partial matches
      bool matchesLabel =
          video.location.toLowerCase().contains(query.toLowerCase());
      bool matchesYear = video.date.year.toString().contains(query);
      bool matchesMonth = DateFormat('MMMM')
              .format(video.date)
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          video.date.month.toString().contains(query);
      bool matchesDay = video.date.day.toString().contains(query);

      if (matchesLabel || matchesYear || matchesMonth || matchesDay) {
        matchQuery.add(video);
      }
    }

    return Container(
      color: Colors.white,
      child: BlocProvider(
        create: (context) => getIT<MoodCubit>(),
        child: GridView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];

            return VideoGrid(
              moodMap: result,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.8,
            mainAxisSpacing: 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    moodCubit.loadMood();
    List<MoodModel> matchQuery = [];

    DateTime? searchDate;
    bool isYearMonth = false;

    try {
      if (query.length == 7 && query.contains('-') ||
          query.length == 6 && query.contains('-')) {
        // Checks for 'yyyy-MM' format
        searchDate = DateFormat('yyyy-MM').parseStrict(query);
        isYearMonth = true;
      } else {
        searchDate = DateFormat('yyyy-MM-dd').parseStrict(query);
      }
    } catch (e) {
      // Handle invalid date format
      searchDate = null;
    }

    for (var video in moodCubit.moods) {
      bool matchesLabel =
          video.location.toLowerCase().contains(query.toLowerCase());

      bool matchesYear = video.date.year.toString().contains(query);
      bool matchesMonth = DateFormat('MMMM')
              .format(video.date)
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          video.date.month.toString().contains(query);
      bool matchesDay = video.date.day.toString().contains(query);

      bool matchesFullDate = searchDate != null &&
          video.date.year == searchDate.year &&
          video.date.month == searchDate.month &&
          video.date.day == searchDate.day;

      bool matchesYearMonth = isYearMonth &&
          video.date.year == searchDate!.year &&
          video.date.month == searchDate.month;

      if (matchesLabel ||
          matchesYear ||
          matchesMonth ||
          matchesDay ||
          matchesFullDate ||
          matchesYearMonth) {
        matchQuery.add(video);
      }
    }
    return Container(
      color: Colors.white,
      child: BlocProvider(
        create: (context) => getIT<MoodCubit>(),
        child: GridView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery.reversed.toList()[index];

            return VideoGrid(
              moodMap: result,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.8,
            mainAxisSpacing: 1,
          ),
        ),
      ),
    );
  }
}
