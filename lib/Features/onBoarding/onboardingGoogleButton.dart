import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class onboardingGoogleButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? Coloring;
  final void Function()? onPressed;
  final String iconData;
  const onboardingGoogleButton(
      {super.key,
      required this.text,
      this.textStyle,
      this.Coloring,
      this.onPressed,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shadowColor: const WidgetStatePropertyAll(Colors.grey),
            elevation: const WidgetStatePropertyAll(3),
            backgroundColor:
                WidgetStatePropertyAll(Coloring ?? ColorsApp.mainOrange),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize:
                const WidgetStatePropertyAll(Size(double.infinity, 52)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              text,
              style: textStyle ??
                  const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
            ),
            Image.asset(
              iconData,
              scale: 50,
            )
          ],
        ));
  }
}
