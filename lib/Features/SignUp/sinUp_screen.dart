import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';
import 'package:video_diary/Features/SignUp/Widgets/emailandpasswordreg.dart';
import 'package:video_diary/Features/SignUp/Widgets/regestierBlocListner.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '  Join Trek ..',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              Icon(Icons.face, size: 20, color: ColorsApp.secLightGrey),
            ],
          ),
          SizedBox(
            height: 9.h,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '  Create your account',
              style: TextStyle(color: ColorsApp.mainColor, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          const EmailAndPasswordReg(),
          GTextButton(
              text: 'Sign up',
              onPressed: () {
                validateThenDoSignup(context);
              }),
          SizedBox(
            height: 15.h,
          ),
          const RegisterBlocListener()
        ],
      ),
    );
  }
}

void validateThenDoSignup(BuildContext context) {
  if (context.read<RegisterCubit>().formKey.currentState!.validate()) {
    context.read<RegisterCubit>().emitRegister();
  }
}
