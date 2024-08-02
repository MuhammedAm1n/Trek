import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Features/Analysis/BargraphAnother/Bargraph.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph({super.key});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List moodEntries = [];
  List reasonEntries = [];
  double maXCountY = 0;

  @override
  void initState() {
    super.initState();
    context.read<MoodCubit>().loadMood();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        if (state is GetMoodSuccess) {
          final reversedList = state.moods.reversed.toList();
          moodEntries =
              List.generate(reversedList.length, (i) => reversedList[i].mood);

          reasonEntries =
              List.generate(state.moods.length, (i) => state.moods[i].why);

          if (moodEntries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/animations/Statistics-bro2.png")
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 10),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Mood Count',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: SizedBox(
                    height: 298,
                    width: 297,
                    child: Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(250),
                      ),
                      color: Colors.white,
                      child: PieChart(PieChartData(
                        sectionsSpace: 5,
                        centerSpaceRadius: 80,
                        sections: _generatePieChartSections(),
                      )),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10),
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'Reason Chart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, bottom: 20.0, right: 10, top: 20),
                  child: SizedBox(
                      height: 400,
                      width: 400,
                      child: LineChartExample(
                        lineSpots: _genereteReason(),
                        y: maXCountY,
                      )),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<FlSpot> _genereteReason() {
    final Map<String, int> reasonCount = {
      "family": 0,
      "friends": 0,
      "work": 0,
      "hobbies": 0,
      "school": 0,
      "love": 0,
      "health": 0,
      "music": 0,
      "food": 0,
      "news": 0,
      "weather": 0,
      "money": 0,
    };

    // List of keys corresponding to the reason categories
    final List<String> keys = [
      "family",
      "friends",
      "work",
      "hobbies",
      "school",
      "love",
      "health",
      "music",
      "food",
      "news",
      "weather",
      "money"
    ];

    for (var reason in reasonEntries) {
      for (int i = 0; i < reason.length; i++) {
        if (reason[i] == 1) {
          reasonCount[keys[i]] = reasonCount[keys[i]]! + 1;
        }
      }
    }
    int maxCount = reasonCount.values.reduce((a, b) => a > b ? a : b);

    // Scale the maximum count for chart display
    final double scaledMaxCount = maxCount.toDouble() * 1.5;

    maXCountY = scaledMaxCount;

    return reasonCount.entries.map((entry) {
      return FlSpot(
        reasonCount.keys.toList().indexOf(entry.key).toDouble(),
        entry.value.toDouble(),
      );
    }).toList();
  }

  List<PieChartSectionData> _generatePieChartSections() {
    final Map<String, int> moodCounts = {
      "Super Great": 0,
      "Pretty well": 0,
      "Completely Fine": 0,
      "Somewhat Bad": 0,
      "Totally Terrible": 0,
    };

    for (var entry in moodEntries) {
      if (entry >= 3) {
        moodCounts["Super Great"] = moodCounts["Super Great"]! + 1;
      } else if (entry >= 1 && entry < 3) {
        moodCounts["Pretty well"] = moodCounts["Pretty well"]! + 1;
      } else if (entry >= -1 && entry < 1) {
        moodCounts["Completely Fine"] = moodCounts["Completely Fine"]! + 1;
      } else if (entry >= -3 && entry < -1) {
        moodCounts["Somewhat Bad"] = moodCounts["Somewhat Bad"]! + 1;
      } else if (entry < -3) {
        moodCounts["Totally Terrible"] = moodCounts["Totally Terrible"]! + 1;
      }
    }

    return [
      _createPieChartSection(
        color: const Color(0xfffabab7),
        value: moodCounts["Super Great"]!.toDouble(),
        title: 'Great: ${moodCounts["Super Great"]}',
      ),
      _createPieChartSection(
        color: const Color(0xfff06d9c),
        value: moodCounts["Pretty well"]!.toDouble(),
        title: 'Well: ${moodCounts["Pretty well"]}',
      ),
      _createPieChartSection(
        color: const Color(0xff98c7da),
        value: moodCounts['Completely Fine']!.toDouble(),
        title: 'Fine: ${moodCounts['Completely Fine']}',
      ),
      _createPieChartSection(
        color: const Color(0xff407d8b),
        value: moodCounts['Somewhat Bad']!.toDouble(),
        title: 'Bad: ${moodCounts['Somewhat Bad']}',
      ),
      _createPieChartSection(
        color: const Color(0xffe9c46a),
        value: moodCounts['Totally Terrible']!.toDouble(),
        title: 'Terrible: ${moodCounts['Totally Terrible']}',
      ),
    ];
  }

  PieChartSectionData _createPieChartSection({
    required Color color,
    required double value,
    required String title,
  }) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: 65,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
