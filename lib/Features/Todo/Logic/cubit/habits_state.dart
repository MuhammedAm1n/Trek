part of 'habits_cubit.dart';

abstract class HabitsState {}

final class HabitsInitial extends HabitsState {}

final class HabitLoading extends HabitsState {}

final class HabitSucess extends HabitsState {
  final List<HabitModel> habit;
  HabitSucess({required this.habit});
}

final class HabitFaliuer extends HabitsState {
  final String messge;
  HabitFaliuer({required this.messge});
}

final class InsertHabitLoading extends HabitsState {}

final class InsertHabitSucess extends HabitsState {}

final class InsertHabitFaliuer extends HabitsState {
  final String messge;
  InsertHabitFaliuer({required this.messge});
}
