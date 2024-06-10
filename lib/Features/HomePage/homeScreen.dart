// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/HomePage/Widgets/TimeBar.dart';
import 'package:video_diary/Features/HomePage/Widgets/VideoCard.dart';

import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.MoodSelect);
        },
        backgroundColor: ColorsApp.mainOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DiaryV',
          style: TextStyle(color: Colors.black, fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded),
            color: Colors.black,
            iconSize: 26,
          ),
          SizedBox(
            width: 8,
          )
        ],
        backgroundColor: ColorsApp.Navigationbar,
      ),
      body: Container(
        color: Colors.grey.shade800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimeBar(),
            SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: ColorsApp.darkGrey,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(70)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                          child: Datetime(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      listVeiw()
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Datetime() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return Row(
        children: [
          Text("Good Morning",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Morning.json', height: 30, width: 30)
        ],
      );
    } else if (hour >= 12 && hour < 17) {
      return Row(
        children: [
          Text("Good Afternoon",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/Afternon.json', height: 30, width: 30)
        ],
      );
    } else {
      return Row(
        children: [
          Text("Good Evening",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorsApp.mainOrange)),
          SizedBox(
            width: 5,
          ),
          Lottie.asset('assets/emotions/night.json', height: 30, width: 30)
        ],
      );
    }
  }

  Widget listVeiw() {
    return Expanded(
        child: ListView(
      children: [
        FutureBuilder(
            future: context.read<MoodCubit>().emitGetMood(),
            builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final reversedList = snapshot.data!.reversed.toList();
                    return VideoCard(
                        moodMap: reversedList[i],
                        deletTap: (p0) {
                          setState(() {
                            return context
                                .read<MoodCubit>()
                                .emitDeleteMood(reversedList[i]["id"]);
                          });
                        });
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })
      ],
    ));
  }
}
