import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';

class EmailAndPasswordReg extends StatelessWidget {
  const EmailAndPasswordReg({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<RegisterCubit>().formKey,
      child: SizedBox(
        height: 350,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppTextFormField(
                keyboardType: TextInputType.name,
                hintText: 'Username',
                controller: context.read<RegisterCubit>().userName,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              AppTextFormField(
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                controller: context.read<RegisterCubit>().email,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              AppTextFormField(
                hintText: 'Password',
                controller: context.read<RegisterCubit>().password,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  } else if (context
                          .read<RegisterCubit>()
                          .password
                          .text
                          .characters
                          .length <
                      8) {
                    return 'Must contains at least 8 char';
                  }
                },
              ),
              SizedBox(
                height: 15.h,
              ),
              AppTextFormField(
                hintText: 'Confirm Password',
                controller: context.read<RegisterCubit>().passwordconf,
                validator: (value) {
                  if (value != context.read<RegisterCubit>().password.text ||
                      value.isEmpty) {
                    return 'Confirm Password dosen\'t match. Try again!';
                  }
                },
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
