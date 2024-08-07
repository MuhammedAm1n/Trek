import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';

class TaskTile extends StatelessWidget {
  final VoidCallback onTap;
  final TaskModel habitTile;
  final void Function(BuildContext)? deletTap;
  final VoidCallback? updateTap;

  const TaskTile({
    super.key,
    required this.onTap,
    this.deletTap,
    this.updateTap,
    required this.habitTile,
  });

  // Convert seconds into minutes and seconds
  String convertingMintoSec(int totalSeconds) {
    int sec = totalSeconds % 60;
    int min =
        totalSeconds ~/ 60; // Use integer division to get the number of minutes

    // Format seconds to always be two digits
    String secStr = sec.toString().padLeft(2, '0');
    return '$min:$secStr';
  }

  // Calculate progress percentage
  double percentegeDone() {
    // Avoid division by zero
    if (habitTile.timeGoal == 0) return 0;
    return habitTile.timeSpent / (habitTile.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    bool habitPausedbool = habitTile.timeSpent / 60 == habitTile.timeGoal
        ? !habitTile.paused
        : habitTile.paused;

    bool finished = habitTile.timeSpent / 60 == habitTile.timeGoal
        ? !habitTile.paused
        : false;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deletTap?.call(context),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Color(habitTile.color!),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Indicator
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
                            backgroundColor:
                                const Color.fromARGB(255, 228, 225, 225),
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
                              child: Icon(habitPausedbool
                                  ? Icons.play_arrow
                                  : Icons.pause))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Name
                        Text(
                          habitTile.habitName,
                          style: TextStyle(
                              decorationThickness: 3,
                              decoration:
                                  finished ? TextDecoration.lineThrough : null,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        // Progress
                        Text(
                          '${convertingMintoSec(habitTile.timeSpent)} / ${habitTile.timeGoal}:00',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                ],
              ),
              IconButton(onPressed: updateTap, icon: const Icon(Icons.settings))
            ],
          ),
        ),
      ),
    );
  }
}
