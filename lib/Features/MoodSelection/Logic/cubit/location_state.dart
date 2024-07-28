part of 'location_cubit.dart';

abstract class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSucess extends LocationState {
  final String Location;

  LocationSucess({required this.Location});
}

final class LocationFaliuer extends LocationState {
  final String message;

  LocationFaliuer({required this.message});
}
