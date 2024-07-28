import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_state.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Widgets/AddHabit.dart';
import 'package:video_diary/Features/Todo/Widgets/TodoTile.dart';
import 'package:video_diary/Features/Todo/Widgets/UpdateHabit.dart';

class ProgressTodo extends StatefulWidget {
  const ProgressTodo({super.key});

  @override
  State<ProgressTodo> createState() => _ProgressTodoState();
}

class _ProgressTodoState extends State<ProgressTodo> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    context.read<HabitsCubit>().emitreadHabit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<HabitModel> habitItem = context.read<HabitsCubit>().habits;

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
            "assets/images/Tasks.png",
            scale: 25,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "AddHabit",
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    backgroundColor: ColorsApp.mainColor,
                    title: Center(
                        child: Text(
                      "Add Habit",
                      style: TextStyle(color: Colors.white),
                    )),
                    content: AddHabit(),
                  );
                });
          },
          backgroundColor: ColorsApp.mainOrange,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15.0),
          child: BlocBuilder<HabitsCubit, HabitsState>(
              builder: (BuildContext context, state) {
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HabitSucess) {
              habitItem = state.habit;
              if (habitItem.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Habits Added Yet!',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView(children: [
                ListView.builder(
                  itemCount: habitItem.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final habit = habitItem[i];
                    return ToDoTile(
                      // on Update tile
                      updateTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: ColorsApp.mainColor,
                                title: const Center(
                                    child: Text(
                                  "Update Habit",
                                  style: TextStyle(color: Colors.white),
                                )),
                                content: UpdateHabit(
                                  habitId: habit.id,
                                  habitModel: habit,
                                ),
                              );
                            });
                      },
                      // on delete tile
                      deletTap: (p) {
                        setState(() {
                          return context
                              .read<HabitsCubit>()
                              .emitdeletHabit(habit.id!);
                        });
                        context.read<HabitsCubit>().emitreadHabit();
                      },

                      onTap: () {
                        startPausemethod(habit);
                      },
                      habitName: habit.habitName,

                      timeSpent: habit.timeSpent,
                      timeGoal: habit.timeGoal,
                      habitStarted: habit.timeSpent / 60 == habit.timeGoal
                          ? !habit.paused
                          : habit.paused,
                      finished: habit.timeSpent / 60 == habit.timeGoal
                          ? !habit.paused
                          : false,
                      pallete: habit.color,
                    );
                  },
                ),
              ]);
            }
            return const Text('Some thing happend');
          }),
        ));
  }

  startPausemethod(HabitModel habit) {
    // what the start time is
    var startTime = DateTime.now();
    // includee the time already  elapsed
    int elapsedTime = habit.timeSpent;
    // habit started or stopped
    setState(() {
      habit.paused = !habit.paused;
    });

    // keep the time going
    if (!habit.paused) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (habit.paused) {
            timer.cancel();
            _saveHabit(habit);
          }
          // calculate the time elapsed by comparing current time and start time
          var currentTime = DateTime.now();

          habit.timeSpent = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
          _saveHabit(habit);
          if (habit.timeSpent / 60 == habit.timeGoal) {
            timer.cancel();
            habit.paused == !habit.paused;
            _saveHabit(habit);
            _playFinishSound();
          } else if (habit.timeSpent / 60 > habit.timeGoal) {
            habit.timeSpent = 0;
          }
        });
      });
    }
  }

  _saveHabit(HabitModel habit) {
    context.read<HabitsCubit>().emitUpdateHabit(habit.toMap());
  }

// this for sound after finish habit
  _playFinishSound() async {
    await _audioPlayer.play(AssetSource("sound/Shatoor.mp3"));
  }
}
