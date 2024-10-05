part of 'reminder_cubit.dart';

abstract class ReminderState {}

final class ReminderInitial extends ReminderState {}

final class ReminderLoading extends ReminderState {}

final class ReminderSucess extends ReminderState {}

final class ReminderFaliuer extends ReminderState {
  final String error;

  ReminderFaliuer({required this.error});
}
