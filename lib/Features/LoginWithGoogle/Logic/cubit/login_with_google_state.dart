part of 'login_with_google_cubit.dart';

abstract class LoginWithGoogleState {}

final class LoginWithGoogleInitial extends LoginWithGoogleState {}

final class LoginWithGoogleLoading extends LoginWithGoogleState {}

final class LoginWithGoogleSuccess extends LoginWithGoogleState {}

final class LoginWithGoogleError extends LoginWithGoogleState {
  final String error;
  LoginWithGoogleError({required this.error});
}
