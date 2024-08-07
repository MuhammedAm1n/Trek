import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Tasks/Data/Backgroundservices/HandleBackgroundServices.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_cubit.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_state.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Tasks/Widgets/AddTask.dart';
import 'package:video_diary/Features/Tasks/Widgets/TaskTile.dart';
import 'package:video_diary/Features/Tasks/Widgets/UpdateTask.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> with WidgetsBindingObserver {
  List<TaskModel> _habitItems = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Timer? _timer;
  final HandleBackgroundServices _backgroundServices =
      HandleBackgroundServices();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHabits();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundServices.handleDetachedState();
    FlutterBackgroundService().invoke('stop');
    _timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _updatePausedStateForAllHabits();
        _backgroundServices.handleDetachedState();
        break;
      case AppLifecycleState.paused:
        _backgroundServices.handlePausedState();
        break;
      case AppLifecycleState.inactive:
        _backgroundServices.handleInactiveState();
        break;
      case AppLifecycleState.resumed:
        _backgroundServices.handleResumedState();
        break;
      default:
        break;
    }
  }

  void _loadHabits() {
    final habits = context.read<TaskCubit>().emitReadTask();
    setState(() {
      _habitItems = habits;
    });
    for (var i = 0; i < _habitItems.length; i++) {
      _listKey.currentState?.insertItem(i);
    }
  }

  void _updatePausedStateForAllHabits() {
    for (var habit in _habitItems) {
      if (!habit.paused) {
        habit.paused = true;
        _saveHabit(habit);
        FlutterBackgroundService().invoke('pause', {
          "habitName": habit.habitName,
          "taskId": habit.id,
        });
      }
    }
  }

  void _pauseAllTasksExcept(TaskModel taskToExclude) {
    for (var habit in _habitItems) {
      if (habit.id != taskToExclude.id && !habit.paused) {
        habit.paused = true;
        _saveHabit(habit);
        FlutterBackgroundService().invoke('pause', {
          "habitName": habit.habitName,
          "taskId": habit.id,
        });
      }
    }
  }

  void _startPauseMethod(TaskModel habit) async {
    // Debug print to check the flow

    var startTime = DateTime.now();
    int elapsedTime = habit.timeSpent;

    setState(() {
      habit.paused = !habit.paused;
      _saveHabit(habit);
    });

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
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          if (habit.paused) {
            timer.cancel();
            _saveHabit(habit);
            return;
          }

          var currentTime = DateTime.now();
          habit.timeSpent = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);

          _saveHabit(habit);

          if (habit.timeSpent / 60 == habit.timeGoal) {
            timer.cancel();
            habit.paused = false;
            FlutterBackgroundService().invoke(
                "finish", {"habitName": habit.habitName, "taskId": habit.id});
            _saveHabit(habit);
            _playFinishSound();
          } else if (habit.timeSpent / 60 > habit.timeGoal) {
            habit.timeSpent = 0;
          }
        });
      });
    } else {
      setState(() {
        FlutterBackgroundService().invoke('pause', {
          "habitName": habit.habitName,
          "taskId": habit.id,
          "elapsedTime": elapsedTime,
          "startTime": startTime.toIso8601String()
        });
      });
    }
  }

  void _saveHabit(TaskModel habit) {
    context.read<TaskCubit>().emitUpdateTask(habit.toMap());
  }

  void _addHabit(TaskModel habit) {
    setState(() {
      _habitItems.add(habit);
    });
    _listKey.currentState?.insertItem(_habitItems.length - 1);
  }

  void _deleteHabit(int index) {
    final habit = _habitItems[index];
    FlutterBackgroundService()
        .invoke("delete", {"habitName": habit.habitName, "taskId": habit.id});
    context.read<TaskCubit>().emitDeleteTask(habit.id);
    setState(() {
      _habitItems.removeAt(index);
    });
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildHabitTile(habit, index, animation),
    );
  }

  _updateHabit(TaskModel habit, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorsApp.backGround,
          title: const Center(
            child: Text(
              "Edit Task",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
          content: UpdateTask(habitModel: habit),
        );
      },
    ).then((_) {
      setState(() {
        _habitItems[index] = habit;
      });
    });
  }

  _updateTaskWhileRunning(TaskModel task) {
    for (var task in _habitItems) {
      if (!task.paused) {
        task.paused = true;
        _saveHabit(task);
        FlutterBackgroundService()
            .invoke("update", {"habitName": task.habitName, "taskId": task.id});
        _timer?.cancel();
      }
    }
  }

  Widget _buildHabitTile(
      TaskModel habit, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: TaskTile(
        habitTile: habit,
        onTap: () {
          _startPauseMethod(habit);
        },
        deletTap: (p) {
          _deleteHabit(index);
        },
        updateTap: () {
          _updateHabit(habit, index);
          _updateTaskWhileRunning(habit);
        },
      ),
    );
  }

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
          "assets/images/Tasks.png",
          scale: 27,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "AddHabit",
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: ColorsApp.backGround,
                title: const Center(
                  child: Text(
                    "Add Task",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                content: AddTask(onHabitAdded: (newHabit) {
                  _addHabit(newHabit);
                }),
              );
            },
          );
        },
        backgroundColor: ColorsApp.mainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15.0),
        child: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskSucess) {
              setState(() {
                _habitItems = state.habit;
              });
              for (var i = 0; i < _habitItems.length; i++) {
                _listKey.currentState?.insertItem(i);
              }
            }
          },
          builder: (context, state) {
            if (_habitItems.isEmpty) {
              return Center(
                child: Image.asset("assets/animations/Checklist-bro.png"),
              );
            }
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TaskSucess || _habitItems.isNotEmpty) {
              return AnimatedList(
                key: _listKey,
                initialItemCount: _habitItems.length,
                itemBuilder: (context, index, animation) {
                  if (index < 0 || index >= _habitItems.length) {
                    return const SizedBox
                        .shrink(); // Return an empty widget if index is invalid
                  }
                  final habit = _habitItems[index];
                  return _buildHabitTile(habit, index, animation);
                },
              );
            }
            return Center(
              child: Image.asset("assets/animations/Checklist-bro.png"),
            );
          },
        ),
      ),
    );
  }

  Future<void> _playFinishSound() async {
    await _audioPlayer.play(AssetSource("sound/Clapping.mp3"));
  }
}
