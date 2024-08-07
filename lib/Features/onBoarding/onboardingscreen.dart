import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Login/Logic/cubit/login_cubit.dart';
import 'package:video_diary/Features/Login/LoginScreen.dart';
import 'package:video_diary/Features/LoginWithGoogle/GoogleBlockListener.dart';
import 'package:video_diary/Features/LoginWithGoogle/Logic/cubit/login_with_google_cubit.dart';
import 'package:video_diary/Features/SignUp/Logic/cubit/register_cubit.dart';
import 'package:video_diary/Features/SignUp/sinUp_screen.dart';
import 'package:video_diary/Features/onBoarding/onboardingButton.dart';
import 'package:video_diary/Features/onBoarding/onboardingGoogleButton.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/NEW.png',
                scale: 8,
              ),

              SizedBox(
                height: 40.h,
              ),
              const Text(
                textAlign: TextAlign.center,
                "Capture life's moments, \n relive memories like never before,\n track your goals!",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 110.h,
              ),
              // Normal Login
              onboardingButton(
                Coloring: ColorsApp.mainColor,
                text: 'Log in with Account',
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: ColorsApp.backGround,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      context: context,
                      builder: (context) => BlocProvider(
                            create: (context) => getIT<LoginCubit>(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: const LoginScreen(),
                            ),
                          ));
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              // Login With Google
              onboardingGoogleButton(
                iconData: 'assets/images/Google__G__logo.svg.png',
                text: 'Log in with Google',
                textStyle: const TextStyle(color: Colors.black),
                Coloring: Colors.white,
                onPressed: () {
                  context.read<LoginWithGoogleCubit>().emitloginWithGooglel();
                },
              ),
              const GoogleBlockListener(),

              SizedBox(
                height: 8.h,
              ),

              // Sign Up  or Register
              onboardingButton(
                Coloring:const Color(0xff48908c),
                text: 'Sign up for free',
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: ColorsApp.backGround,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      context: context,
                      builder: (context) => BlocProvider(
                            create: (context) => getIT<RegisterCubit>(),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: const SignupScreen(),
                            ),
                          ));
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
