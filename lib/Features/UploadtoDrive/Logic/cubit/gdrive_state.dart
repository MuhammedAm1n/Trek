part of 'gdrive_cubit.dart';

sealed class GdriveState {}

final class GdriveInitial extends GdriveState {}

final class GdriveLoading extends GdriveState {}

final class GdriveSucess extends GdriveState {}

final class GdriveFaliuer extends GdriveState {
  final String message;

  GdriveFaliuer({required this.message});
}
