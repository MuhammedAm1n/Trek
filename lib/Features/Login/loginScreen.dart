import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:video_diary/Features/Login/widgets/Terms_conditions.dart';
import 'package:video_diary/Features/Login/widgets/loginBlockListener.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(color: ColorsApp.mainOrange, fontSize: 20),
                ),
                Icon(Icons.face, size: 20, color: Colors.white)
              ],
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          AppTextFormField(
            hintText: 'Email',
            controller: context.read<LoginCubit>().email,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
            },
          ),
          SizedBox(
            height: 15.h,
          ),
          AppTextFormField(
              controller: context.read<LoginCubit>().password,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter username';
                }
              },
              hintText: 'Password',
              IsObscureText: isObscure,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: Icon(
                  !isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          SizedBox(
            height: 20.h,
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                  fontSize: 13,
                  color: ColorsApp.mainOrange,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          GTextButton(
            text: 'Log in',
            onPressed: () {
              context.read<LoginCubit>().emitLogin();
            },
          ),
          SizedBox(
            height: 30.h,
          ),
          const TermsandConditions(),
          SizedBox(
            height: 50.h,
          ),
          const LoginBlockListener()
        ],
      ),
    );
  }
}
