import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Widgets/WidgetsOfAddHabit/ColorItem.dart';

class ListVeiwColorsItem extends StatefulWidget {
  const ListVeiwColorsItem({super.key});

  @override
  State<ListVeiwColorsItem> createState() => _ListVeiwColorsItemState();
}

class _ListVeiwColorsItemState extends State<ListVeiwColorsItem> {
  int currentIndex = 0;
  List<Color> colors = const [
    Color(0xfffabab7),
    Color(0xfff06d9c),
    Color(0xff98c7da),
    Color(0xff407d8b),
    Color(0xffe9c46a)
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35 * 6,
      height: 35 * 2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                  onTap: () {
                    currentIndex = index;
                    BlocProvider.of<HabitsCubit>(context).color =
                        colors[currentIndex];
                    setState(() {});
                  },
                  child: ColorITem(
                    isActive: currentIndex == index,
                    color: colors[index],
                  )));
        },
      ),
    );
  }
}
