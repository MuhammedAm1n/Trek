import 'package:get_it/get_it.dart';
import 'package:video_diary/Core/LocalDatabase/HabitDatabase.dart';
import 'package:video_diary/Core/LocalDatabase/LocalDB.dart';
import 'package:video_diary/Core/networking/ApiServices.dart';
import 'package:video_diary/Features/Login/Data/Repositry/Repo.dart';
import 'package:video_diary/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:video_diary/Features/LoginWithGoogle/Data/Repo/LoginWithGmailRepo.dart';
import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/MoodRepo.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/SignUp/Data/Repositry/RegisterRepo.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Repo/Habitrepo.dart';

final getIT = GetIt.instance;
Future<void> SetUpGit() async {
  getIT.registerLazySingleton<ApiServices>(() => ApiServices());
  getIT.registerLazySingleton<LocalDb>(() => LocalDb());
  getIT.registerLazySingleton<HabitDatabase>(() => HabitDatabase());

  //Login
  getIT.registerLazySingleton<LoginRepo>(() => LoginRepo(apiServices: getIT()));
  getIT.registerFactory<LoginCubit>(() => LoginCubit(getIT()));

  //reGsiter
  getIT.registerLazySingleton<RegisterRepo>(
      () => RegisterRepo(apiServices: getIT()));
  getIT.registerFactory<RegisterCubit>(() => RegisterCubit(getIT()));

  //LoginWithGmail
  getIT.registerLazySingleton<LoginWithGmailRepo>(
      () => LoginWithGmailRepo(apiServices: getIT()));
  getIT.registerFactory<LoginWithGoogleCubit>(
      () => LoginWithGoogleCubit(getIT()));

  //Moods
  getIT.registerLazySingleton<MoodRepo>(() => MoodRepo(db: getIT()));
  getIT.registerFactory<MoodCubit>(() => MoodCubit(getIT()));

  //Habbits
  getIT.registerLazySingleton<HabitRepo>(() => HabitRepo(database: getIT()));
  getIT.registerFactory<HabitsCubit>(() => HabitsCubit(getIT()));
}
