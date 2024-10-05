import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String text;
  final Icon icons;
  final void Function()? onTap;
  const MyTile(
      {super.key, required this.text, required this.icons, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      leading: icons,
      onTap: onTap,
    );
  }
}
