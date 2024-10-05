import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';

abstract class TaskState {}

final class TaskInit extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSucess extends TaskState {
  final List<TaskModel> habit;
  TaskSucess({required this.habit});
}

final class TaskFaliuer extends TaskState {
  final String messge;
  TaskFaliuer({required this.messge});
}

final class InsertTaskLoading extends TaskState {}

final class InsertTaskSuccess extends TaskState {}

final class InsertTaskFaliuer extends TaskState {
  final String messge;
  InsertTaskFaliuer({required this.messge});
}

final class EditTaskSucess extends TaskState {}
