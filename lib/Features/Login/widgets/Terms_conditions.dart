import 'package:flutter/material.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: 'By logging, you agree to our',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400)),
        const TextSpan(
            text: ' Terms & Conditions',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
        TextSpan(
            text: ' and',
            style: TextStyle(
                height: 1.5,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade400)),
        const TextSpan(
            text: ' PrivacyPolicy.',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black)),
      ]),
    );
  }
}
