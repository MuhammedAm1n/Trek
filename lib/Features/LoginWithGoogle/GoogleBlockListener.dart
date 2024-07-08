import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/CustomSnackbar.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';

class GoogleBlockListener extends StatelessWidget {
  const GoogleBlockListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithGoogleCubit, LoginWithGoogleState>(
      listener: (context, state) {
        if (state is LoginWithGoogleLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: ColorsApp.mainOrange,
              ),
            ),
          );
        } else if (state is LoginWithGoogleError) {
          Navigator.pop(context);

          CustomSnackbar.showSnackbar(context, state.error);
          print(state.error);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
