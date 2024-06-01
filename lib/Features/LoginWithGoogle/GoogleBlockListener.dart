import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';

class GoogleBlockListener extends StatelessWidget {
  const GoogleBlockListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithGoogleCubit, LoginWithGoogleState>(
        listener: (context, state) {
          if (state is LoginWithGoogleInitial ||
              state is LoginWithGoogleLoading) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: ColorsApp.mainOrange,
                ),
              ),
            );
          } else if (state is LoginWithGoogleSuccess) {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.MoodSelect);
          } else if (state is LoginWithGoogleError) {
            setupErrorState(context, state.error);
          }
        },
        child: const SizedBox.shrink());
  }

  void setupErrorState(BuildContext context, String error) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 32,
        ),
        content: Text(
          error,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Got it',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
