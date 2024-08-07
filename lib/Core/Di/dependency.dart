import 'package:get_it/get_it.dart';
import 'package:video_diary/Core/LocalDatabase/HabitDatabase.dart';
import 'package:video_diary/Core/LocalDatabase/LocalDB.dart';
import 'package:video_diary/Core/networking/ApiServices.dart';
import 'package:video_diary/Core/networking/FetchLocation.dart';
import 'package:video_diary/Core/networking/Gdrive.dart';
import 'package:video_diary/Features/Login/Data/Repositry/Repo.dart';
import 'package:video_diary/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:video_diary/Features/LoginWithGoogle/Data/Repo/LoginWithGmailRepo.dart';
import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/LocationRepo.dart';
import 'package:video_diary/Features/MoodSelection/Data/Repo/MoodRepo.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/location_cubit.dart';
import 'package:video_diary/Features/MoodSelection/Logic/cubit/mood_cubit.dart';
import 'package:video_diary/Features/Snippets/Data/RemindersRepo.dart';
import 'package:video_diary/Features/Snippets/Logic/cubit/reminder_cubit.dart';
import 'package:video_diary/Features/SignUp/Data/Repositry/RegisterRepo.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_cubit.dart';
import 'package:video_diary/Features/Tasks/Data/Repo/Habitrepo.dart';
import 'package:video_diary/Features/UploadtoDrive/Data/Repo/GdriveRepo.dart';
import 'package:video_diary/Features/UploadtoDrive/Logic/cubit/gdrive_cubit.dart';
import 'package:video_diary/Features/UserPage/Data/Repo/GetUser.dart';
import 'package:video_diary/Features/UserPage/Logic/cubit/user_details_cubit.dart';

final getIT = GetIt.instance;
Future<void> setUpGit() async {
  getIT.registerLazySingleton<ApiServices>(() => ApiServices());
  getIT.registerLazySingleton<FetchLocation>(() => FetchLocation());
  getIT.registerLazySingleton<LocalDb>(() => LocalDb());
  getIT.registerLazySingleton<HabitDatabase>(() => HabitDatabase());
  getIT.registerLazySingleton<GoogleDriveApi>(() => GoogleDriveApi());

// User Details
  getIT.registerLazySingleton<GetUserRepo>(
      () => GetUserRepo(apiServices: getIT()));
  getIT.registerFactory<UserDetailsCubit>(() => UserDetailsCubit(getIT()));

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
  getIT.registerLazySingleton<TaskRepo>(() => TaskRepo(database: getIT()));
  getIT.registerFactory<TaskCubit>(() => TaskCubit(getIT()));

  //Location

  getIT.registerLazySingleton<LocationRepo>(
      () => LocationRepo(fetchlocation: getIT()));
  getIT.registerFactory<LocationCubit>(() => LocationCubit(getIT()));

  // Reminders
  getIT.registerLazySingleton<Remindersrepo>(
      () => Remindersrepo(apiServices: getIT()));
  getIT.registerFactory<ReminderCubit>(() => ReminderCubit(getIT()));

  // GoogleDrive Uploading

  getIT.registerLazySingleton<Gdriverepo>(() => Gdriverepo(getIT()));
  getIT.registerFactory<GdriveCubit>(() => GdriveCubit(getIT()));
}
