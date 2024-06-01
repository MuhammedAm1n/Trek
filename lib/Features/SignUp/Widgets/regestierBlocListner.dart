import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';

class RegisterBlocListener extends StatelessWidget {
  const RegisterBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterInitial || state is RegisterLoading) {
          showDialog(
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: ColorsApp.mainOrange,
              ),
            ),
          );
        } else if (state is RegisterSuccess) {
          Navigator.pop(context);
          showSuccessDialog(context);
        } else if (state is RegisterError) {
          setupErrorState(context, state.message);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Signup Successful'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Congratulations, you have signed up successfully!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Continue'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              disabledForegroundColor: Colors.grey.withOpacity(0.38),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.onboarding);
            },
          ),
        ],
      );
    },
  );
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
        style: TextStyle(color: Colors.blue),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Got it',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
