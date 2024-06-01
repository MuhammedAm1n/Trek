part of 'register_cubit.dart';

abstract class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {}

final class RegisterError extends RegisterState {
  String message;
  RegisterError(this.message);
}
