part of 'user_details_cubit.dart';

abstract class UserDetailsState {}

final class UserDetailsInitial extends UserDetailsState {}

final class UserDetailsSucess extends UserDetailsState {
  final Map<String, dynamic> response;

  UserDetailsSucess({required this.response});
}

final class UserDetailsLoading extends UserDetailsState {}

final class UserDetailsFaliuer extends UserDetailsState {
  final String messge;
  UserDetailsFaliuer(this.messge);
}
