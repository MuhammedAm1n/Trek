import 'package:bloc/bloc.dart';
import 'package:video_diary/Features/UserPage/Data/Repo/GetUser.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final GetUserRepo getUserRepo;

  UserDetailsCubit(this.getUserRepo) : super(UserDetailsInitial());

  Future<void> getUser() async {
    try {
      emit(UserDetailsLoading());
      final userDetails = await getUserRepo.getUser();

      emit(UserDetailsSucess(response: userDetails.data()!));
    } catch (e) {
      emit(UserDetailsFaliuer(e.toString()));
    }
  }

  void resetUserDetails() {
    emit(UserDetailsInitial());
  }
}
