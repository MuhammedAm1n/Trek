import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Analysis/barGraph/barGraph.dart';
import 'package:video_diary/Features/MoodSelection/Data/Model/MoodSelectModel.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

// input List of Moods

// outPut display Nice bie chart
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  List<MoodModel> moodEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.backGround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: ColorsApp.backGround,
        backgroundColor: ColorsApp.backGround,
        shadowColor: ColorsApp.mediumGrey,
        elevation: 1,
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          "assets/images/StatsTrans.png",
          scale: 25,
        ),
      ),
      body: BlocProvider(
        create: (context) => getIT<MoodCubit>(),
        child: const MyBarGraph(),
      ),
    );
  }
}
