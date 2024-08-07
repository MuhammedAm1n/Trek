import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:video_diary/Core/Services/backgroundServices.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_state.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Tasks/Data/Repo/Habitrepo.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo habitRepo;
  List<TaskModel> habits = [];
  Color color = const Color(0xfffabab7);
  final formKey = GlobalKey<FormState>();
  Timer? _timer;

  TaskCubit(this.habitRepo) : super(TaskInit());

  void initDb() {
    habitRepo.setinitDb();
    emit(TaskInit());
  }

  List<TaskModel> emitReadTask() {
    emit(TaskLoading());
    habitRepo.readHabits().then((habits) {
      emit(TaskSucess(habit: habits));
      this.habits = habits;
    });
    return habits;
  }

  void emitInsertTask(TaskModel habit) {
    habit.color = color.value;
    emit(InsertTaskLoading());
    try {
      habitRepo.insertHabit(habit.toMap());
      habit = habit.copyWith(id: habit.id);
      emit(InsertTaskSuccess());
    } on Exception catch (e) {
      emit(InsertTaskFaliuer(messge: e.toString()));
    }
  }

  void emitUpdateTask(Map<String, dynamic> habit) {
    habitRepo.updateHabit(habit);
  }

  void emitEditTask(Map<String, dynamic> habit) {
    habitRepo.updateHabit(habit);
    emit(EditTaskSucess());
  }

  void emitDeleteTask(int id) {
    habitRepo.deleteHabit(id);
  }

  void _playFinishSound() {
    // Implement your sound playing logic here
  }

  void _pauseAllTasksExcept(TaskModel taskToExclude) {
    for (var habit in habits) {
      if (habit.id != taskToExclude.id && !habit.paused) {
        habit.paused = true;
        emitUpdateTask(habit.toMap());
        FlutterBackgroundService().invoke('pause', {
          "habitName": habit.habitName,
          "taskId": habit.id,
        });
      }
    }
  }

  void startPauseMethod(TaskModel habit) {
    initializeService();
    var startTime = DateTime.now();
    int elapsedTime = habit.timeSpent;

    habit.paused = !habit.paused;
    emitUpdateTask(habit.toMap());

    if (!habit.paused) {
      _pauseAllTasksExcept(habit);

      FlutterBackgroundService().invoke('start', {
        "habitName": habit.habitName,
        "taskId": habit.id,
        "elapsedTime": elapsedTime,
        "startTime": startTime.toIso8601String()
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isClosed) {
          timer.cancel();
          return;
        }

        habit.timeSpent =
            elapsedTime + DateTime.now().difference(startTime).inSeconds;

        emitUpdateTask(habit.toMap());

        if (habit.timeSpent / 60 == habit.timeGoal) {
          timer.cancel();
          habit.paused = false;
          FlutterBackgroundService().invoke(
              "finish", {"habitName": habit.habitName, "taskId": habit.id});
          emitUpdateTask(habit.toMap());
          _playFinishSound();
        } else if (habit.timeSpent / 60 > habit.timeGoal) {
          habit.timeSpent = 0;
        }
      });
    } else {
      FlutterBackgroundService().invoke('pause', {
        "habitName": habit.habitName,
        "taskId": habit.id,
        "elapsedTime": elapsedTime,
        "startTime": startTime.toIso8601String()
      });
      _timer?.cancel();
    }
  }
}
