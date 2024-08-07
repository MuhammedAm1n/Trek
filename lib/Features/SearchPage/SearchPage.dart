import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_diary/Core/Widgets/VideoFrame.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';

  @override
  void initState() {
    super.initState();

    context.read<MoodCubit>().loadMood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backGround,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: TextField(
          autofocus: true,
          cursorColor: ColorsApp.mainColor,
          decoration: const InputDecoration(
            hintText: 'Search by dates, places...',
            border: InputBorder.none,
          ),
          onChanged: (searchQuery) {
            setState(() {
              query = searchQuery;
            });
          },
        ),
      ),
      body: BlocBuilder<MoodCubit, MoodState>(
        builder: (context, state) {
          if (state is GetMoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetMoodSuccess) {
            List<MoodModel> matchQuery = _getMatchingMoods(state.moods);
            return matchQuery.isEmpty
                ? const Center(child: Text("No results found"))
                : GridView.builder(
                    itemCount: matchQuery.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.8,
                      mainAxisSpacing: 1,
                    ),
                    itemBuilder: (context, index) {
                      var result = matchQuery[index];
                      return VideoGrid(
                        moodMap: result,
                      );
                    },
                  );
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }

  List<MoodModel> _getMatchingMoods(List<MoodModel> moods) {
    List<MoodModel> matchQuery = [];

    DateTime? searchDate;
    bool isYearMonth = false;

    try {
      if (query.length == 7 && query.contains('-') ||
          query.length == 6 && query.contains('-')) {
        searchDate = DateFormat('yyyy-MM').parseStrict(query);
        isYearMonth = true;
      } else {
        searchDate = DateFormat('yyyy-MM-dd').parseStrict(query);
      }
    } catch (e) {
      searchDate = null;
    }

    for (var video in moods) {
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

    return matchQuery;
  }
}
