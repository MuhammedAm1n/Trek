// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

// ignore: must_be_immutable
class ToDoTile extends StatefulWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  int timeSpent;
  final int timeGoal;
  bool habitStarted;
  final void Function(BuildContext)? deletTap;
  ToDoTile(
      {super.key,
      required this.habitName,
      required this.onTap,
      required this.settingsTapped,
      required this.timeSpent,
      required this.timeGoal,
      required this.habitStarted,
      this.deletTap});

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
//convert seconds into min 61 > 1:02
  String convertingMintoSec(int totalSeconds) {
    String sec = (totalSeconds % 60).toString();
    String min = (totalSeconds / 60).toStringAsFixed(5);

    // if sec is a 1 digit number , place a 0 infornt of it
    if (sec.length == 1) {
      sec = '0' + sec;
    }

    // if min is a 1 digit number
    if (min[1] == ".") {
      min = min.substring(0, 1);
    }
    return min + ' : ' + sec;
  }

// Calculate proggress percentage
  double percentegeDone() {
    return widget.timeSpent / (widget.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: widget.deletTap,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: ColorsApp.mainOrange,
              borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circural Indcitor
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onTap,
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          CircularPercentIndicator(
                            progressColor: percentegeDone() > 0.5
                                ? (percentegeDone() > 0.75
                                    ? Colors.green
                                    : Colors.orange)
                                : Colors.red,
                            radius: 30,
                            percent:
                                percentegeDone() < 1 ? percentegeDone() : 1,
                          ),
                          Center(
                              child: Icon(widget.habitStarted
                                  ? Icons.play_arrow
                                  : Icons.pause))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TodoName
                        Text(
                          widget.habitName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 4,
                        ), // progress
                        Text(
                          convertingMintoSec(widget.timeSpent) +
                              ' / ' +
                              widget.timeGoal.toString() +
                              ": 00",
                          style: TextStyle(color: Colors.white),
                        ),
                      ]),
                ],
              ),
              GestureDetector(
                  onTap: widget.settingsTapped, child: Icon(Icons.settings))
            ],
          ),
        ),
      ),
    );
  }
}
