import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Login/Logic/cubit/login_cubit.dart';

class LoginBlockListener extends StatelessWidget {
  const LoginBlockListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading || state is LoginInitial) {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: ColorsApp.mainOrange,
                ),
              ),
            );
          } else if (state is LoginSuccess) {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.homeScreen);
          } else if (state is LoginError) {
            setupErrorState(context, state.messge);
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
