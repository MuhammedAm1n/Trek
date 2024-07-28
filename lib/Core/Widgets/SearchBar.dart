import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class SearchBarHome extends StatelessWidget {
  final void Function()? onTap;

  const SearchBarHome({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black,
              blurStyle: BlurStyle.inner,
              spreadRadius: 0.5)
        ],
        borderRadius: BorderRadius.circular(15),
        color: ColorsApp.backGround,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorOpacityAnimates: true,
              keyboardType: TextInputType.none,
              cursorColor: ColorsApp.mainColor,
              onTap: onTap,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: ColorsApp.secLightGrey,
                ),
                hintText: '  Search for videos.',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
    );
  }
}
