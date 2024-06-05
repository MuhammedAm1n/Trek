import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Logic/cubit/habits_cubit.dart';
import 'package:video_diary/Features/Todo/Widgets_Todo/AddHabit.dart';
import 'package:video_diary/Features/Todo/Widgets_Todo/ToDotile.dart';

class ProgressTodo extends StatefulWidget {
  const ProgressTodo({super.key});

  @override
  State<ProgressTodo> createState() => _ProgressTodoState();
}

class _ProgressTodoState extends State<ProgressTodo> {
  @override
  void initState() {
    context.read<HabitsCubit>().emitreadHabit();
    super.initState();
  }

  Widget build(BuildContext context) {
    List<HabitModel> habitItem = context.read<HabitsCubit>().habits;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Progress ToDo'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(child: Text("Add Habit")),
                    content: AddHabit(),
                  );
                });
          },
          child: Icon(Icons.add),
          backgroundColor: ColorsApp.mainOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        body: ListView(
          children: [
            BlocBuilder<HabitsCubit, HabitsState>(
                builder: (BuildContext context, state) {
              if (state is HabitLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is HabitSucess) {
                habitItem = state.habit;
                return ListView.builder(
                  itemCount: habitItem.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final habit = habitItem[i];
                    return ToDoTile(
                        deletTap: (p) {
                          setState(() {
                            return context
                                .read<HabitsCubit>()
                                .emitdeletHabit(habit.id!);
                          });
                          context.read<HabitsCubit>().emitreadHabit();
                        },
                        habitName: habit.habitName,
                        onTap: () {
                          Start_pauseMethod(habit);
                        },
                        settingsTapped: () {},
                        timeSpent: habit.timeSpent,
                        timeGoal: habit.timeGoal,
                        habitStarted: habit.paused);
                  },
                );
              } else {
                return Text('Shit');
              }
            }),
          ],
        ));
  }

  Start_pauseMethod(HabitModel habit) {
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
        });
      });
    }
  }

  _saveHabit(HabitModel habit) {
    context.read<HabitsCubit>().emitUpdateHabit(habit.toMap());
  }
}
