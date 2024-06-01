import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph({super.key});

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List moodEntries = [];
  Future<List<Map<dynamic, dynamic>>>? x;
  @override
  void initState() {
    super.initState();
    x = context.read<MoodCubit>().emitGetMood();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: x,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final reversedList = snapshot.data!.reversed.toList();
          moodEntries = List.generate(
              reversedList.length, (i) => reversedList[i]["mood"]);
          return Center(
            child: PieChart(PieChartData(
              sectionsSpace: 5,
              centerSpaceRadius: 120,
              sections: _generatePieChartSections(),
            )),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  List<PieChartSectionData> _generatePieChartSections() {
    Map<String, int> moodCounts = {
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
      PieChartSectionData(
        color: Colors.green,
        value: moodCounts["Super Great"]!.toDouble(),
        title: '"Great": ${moodCounts["Super Great"]}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: moodCounts["Pretty well"]!.toDouble(),
        title: 'well: ${moodCounts["Pretty well"]}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: moodCounts['Completely Fine']!.toDouble(),
        title: 'Fine: ${moodCounts['Completely Fine']}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: moodCounts['Somewhat Bad']!.toDouble(),
        title: 'Bad: ${moodCounts['Somewhat Bad']}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.yellow,
        value: moodCounts['Totally Terrible']!.toDouble(),
        title: 'Terrible: ${moodCounts['Totally Terrible']}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}
