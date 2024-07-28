import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_state.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Data/Repo/Habitrepo.dart';

class HabitsCubit extends Cubit<HabitsState> {
  final HabitRepo habitRepo;
  List<HabitModel> habits = [];
  Color color = const Color(0xfffabab7);
  final formKey = GlobalKey<FormState>();
  HabitsCubit(this.habitRepo) : super(HabitsInitial());

  initDb() {
    habitRepo.setinitDb();
    emit(HabitsInitial());
  }

  List<HabitModel> emitreadHabit() {
    emit(HabitLoading());

    habitRepo.readHabits().then((habits) {
      emit(HabitSucess(habit: habits));
      this.habits = habits;
    });

    return habits;
  }

  void emitInsertHabit(HabitModel habit) {
    habit.color = color.value;
    emit(InsertHabitLoading());
    try {
      habitRepo.insertHabit(habit.toMap());
      emit(InsertHabitSucess());
    } on Exception catch (e) {
      emit(InsertHabitFaliuer(messge: e.toString()));
    }
  }

  void emitUpdateHabit(Map<String, dynamic> habit) {
    habitRepo.updateHabit(habit);
  }

  void emitEditHabit(Map<String, dynamic> habit) {
    habitRepo.updateHabit(habit);
    emit(EditHabitSuccess());
  }

  void emitdeletHabit(int id) {
    habitRepo.deleteHabit(id);
  }
}
