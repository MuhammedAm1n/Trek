import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;

  final int? pallete;
  int timeSpent;
  final int timeGoal;
  bool habitStarted;
  bool finished;
  final void Function(BuildContext)? deletTap;
  void Function()? updateTap;
  ToDoTile(
      {super.key,
      required this.habitName,
      required this.onTap,
      required this.timeSpent,
      required this.timeGoal,
      required this.habitStarted,
      required this.finished,
      this.deletTap,
      required this.pallete,
      this.updateTap});

//convert seconds into min 61 > 1:02
  convertingMintoSec(int totalSeconds) {
    String sec = (totalSeconds % 60).toString();
    String min = (totalSeconds / 60).toStringAsFixed(2);

    // if sec is a 1 digit number , place a 0 infornt of it
    if (sec.length == 1) {
      sec = '0$sec';
    }

    // if min is a 1 digit number
    if (min[1] == ".") {
      min = min.substring(0, 1);
    }
    return '$min : $sec';
  }

// Calculate proggress percentage
  double percentegeDone() {
    return timeSpent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deletTap,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Color(pallete!), borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circural Indcitor
              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
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
                              child: Icon(habitStarted
                                  ? Icons.play_arrow
                                  : Icons.pause))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TodoName
                        Text(
                          habitName,
                          style: TextStyle(
                              decorationThickness: 3,
                              decoration:
                                  finished ? TextDecoration.lineThrough : null,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 4,
                        ), // progress
                        Text(
                          convertingMintoSec(timeSpent) +
                              ' / ' +
                              timeGoal.toString() +
                              ": 00",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                ],
              ),
              GestureDetector(
                  onTap: updateTap, child: const Icon(Icons.settings))
            ],
          ),
        ),
      ),
    );
  }
}
