part of 'mood_cubit.dart';

abstract class MoodState {}

final class MoodInitial extends MoodState {}

final class GetMoodLoading extends MoodState {}

final class GetMoodSuccess extends MoodState {}

final class GetMoodFalier extends MoodState {
  final String messge;

  GetMoodFalier({required this.messge});
}
/////////////////////////////////////////////////////////////

final class DeleteMoodSuccess extends MoodState {}

final class DeleteMoodLoading extends MoodState {}

final class DeleteMoodFailuer extends MoodState {
  final String messge;

  DeleteMoodFailuer({required this.messge});
}
////////////////////////////////////////////////////////////////

final class InsertMoodSuccess extends MoodState {}

final class InsertMoodLoading extends MoodState {}

final class InsertMoodFailuer extends MoodState {
  final String messge;

  InsertMoodFailuer({required this.messge});
}
