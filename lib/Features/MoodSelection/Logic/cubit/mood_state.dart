part of 'mood_cubit.dart';

abstract class MoodState {}

final class MoodInitial extends MoodState {}

final class GetMoodLoading extends MoodState {}

final class GetMoodSuccess extends MoodState {
  final List<MoodModel> moods;

  GetMoodSuccess({required this.moods});
}

final class GetMoodFailure extends MoodState {
  final String message;

  GetMoodFailure({required this.message});
}
/////////////////////////////////////////////////////////////

final class DeleteMoodSuccess extends MoodState {}

final class DeleteMoodLoading extends MoodState {}

final class DeleteMoodFailure extends MoodState {
  final String message;

  DeleteMoodFailure({required this.message});
}
////////////////////////////////////////////////////////////////

final class InsertMoodSuccess extends MoodState {}

final class InsertMoodLoading extends MoodState {}

final class InsertMoodFailure extends MoodState {
  final String message;

  InsertMoodFailure({required this.message});
}

final class UpdateMoodSuccess extends MoodState {
  final List<MoodModel> moods;

  UpdateMoodSuccess({required this.moods});
}

final class UpdateMoodLoading extends MoodState {}

final class UpdateMoodFailure extends MoodState {
  final String message;

  UpdateMoodFailure({required this.message});
}
