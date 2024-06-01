import 'package:flutter/material.dart';
import 'package:video_diary/Features/Analysis/barGraph/barGraph.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';

// input List of Moods

// outPut display Nice bie chart
class AnalysisPage extends StatefulWidget {
  AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  List<MoodModel> moodEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnalysisPage'),
      ),
      body: const Padding(
        padding: const EdgeInsets.all(30.0),
        child: MyBarGraph(),
      ),
    );
  }
}
