import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class onboardingButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? Coloring;
  final void Function()? onPressed;
  const onboardingButton(
      {super.key,
      required this.text,
      this.textStyle,
      this.Coloring,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Coloring ?? ColorsApp.mainOrange),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize:
              const MaterialStatePropertyAll(Size(double.infinity, 52)),
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))),
      child: Text(
        text,
        style: textStyle ??
            const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
