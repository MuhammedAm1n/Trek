import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Services/backgroundServices.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Backgroundservices/HandleBackgroundServices.dart';
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

class _ProgressTodoState extends State<ProgressTodo>
    with WidgetsBindingObserver {
  List<HabitModel> _habitItems = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Timer? _timer; // Declare a timer variable
  final HandleBackgroundServices _backgroundServices =
      HandleBackgroundServices();
  void _loadHabits() {
    final habits = context.read<HabitsCubit>().emitreadHabit();
    setState(() {
      _habitItems = habits;
    });
    for (var i = 0; i < _habitItems.length; i++) {
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeService();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    print('Observer added'); // Debug log
    _loadHabits();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _backgroundServices
        .handleDetachedState(); // Ensure background service is stopped
    print('Observer removed'); // Debug log
    FlutterBackgroundService().invoke('stop');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Lifecycle state changed: $state');
    switch (state) {
      case AppLifecycleState.detached:
        {
          {
            _updatePausedStateForAllHabits();
            _backgroundServices.handleDetachedState();
            print("done");
          }
        }
        break;
      case AppLifecycleState.paused:
        {
          _backgroundServices.handlePausedState();
        }
        break;
      case AppLifecycleState.inactive:
        _backgroundServices.handleInactiveState();
        break;
      case AppLifecycleState.resumed:
        {
          _backgroundServices.handleResumedState();
        }
        break;
      default:
        print('Unhandled lifecycle state: $state');
    }
  }

  void _updatePausedStateForAllHabits() {
    for (var habit in _habitItems) {
      if (!habit.paused) {
        habit.paused = true;
        _saveHabit(habit);
      }
    }
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
          scale: 26,
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
                content: AddHabit(onHabitAdded: (newHabit) {
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
        child: BlocConsumer<HabitsCubit, HabitsState>(
          listener: (context, state) {
            if (state is HabitSucess) {
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
                  child: Image.asset(
                "assets/animations/Checklist-bro.png",
              ));
            }
            if (state is HabitLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HabitSucess || _habitItems.isNotEmpty) {
              return AnimatedList(
                key: _listKey,
                initialItemCount: _habitItems.length,
                itemBuilder: (context, index, animation) {
                  final habit = _habitItems[index];
                  return _buildHabitTile(habit, index, animation);
                },
              );
            }
            return Center(
                child: Image.asset(
              "assets/animations/Checklist-bro.png",
            ));
          },
        ),
      ),
    );
  }

  Widget _buildHabitTile(
      HabitModel habit, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ToDoTile(
        habitTile: habit,
        onTap: () {
          _startPauseMethod(habit);
        },
        deletTap: (p) {
          _deleteHabit(index);
        },
        updateTap: () {
          _updateHabit(habit, index);
        },
      ),
    );
  }

  void _startPauseMethod(HabitModel habit) {
    var startTime = DateTime.now();
    int elapsedTime = habit.timeSpent;

    setState(() {
      habit.paused = !habit.paused;
      _saveHabit(habit);
    });

    if (!habit.paused) {
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
            habit.paused == false;
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
      FlutterBackgroundService().invoke('pause', {
        "habitName": habit.habitName,
        "taskId": habit.id,
        "elapsedTime": elapsedTime,
        "startTime": startTime.toIso8601String()
      });
      _timer?.cancel();
    }
  }

// Another Section
  void _saveHabit(HabitModel habit) {
    context.read<HabitsCubit>().emitUpdateHabit(habit.toMap());
  }

  void _addHabit(HabitModel habit) {
    setState(() {
      _habitItems.add(habit);
    });
    _listKey.currentState?.insertItem(_habitItems.length - 1);
  }

  void _deleteHabit(int index) {
    final habit = _habitItems[index];
    FlutterBackgroundService()
        .invoke("delete", {"habitName": habit.habitName, "taskId": habit.id});
    context.read<HabitsCubit>().emitdeletHabit(habit.id);
    setState(() {
      _habitItems.removeAt(index);
    });
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildHabitTile(habit, index, animation),
    );
  }

  void _updateHabit(HabitModel habit, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorsApp.mainColor,
          title: const Center(
            child: Text(
              "Update Habit",
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: UpdateHabit(
            habitModel: habit,
          ),
        );
      },
    ).then((_) {
      setState(() {
        _habitItems[index] = habit;
      });
    });
  }

  Future<void> _playFinishSound() async {
    await _audioPlayer.play(AssetSource("sound/Clapping.mp3"));
  }
}
