part of 'login_cubit.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final dynamic response;

  LoginSuccess(this.response);
}

final class LoginError extends LoginState {
  final String messge;
  LoginError(this.messge);
}
