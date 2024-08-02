import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_state.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Widgets/WidgetsOfAddHabit/VeiwColorsITem.dart';

class UpdateHabit extends StatefulWidget {
  final HabitModel habitModel;

  const UpdateHabit({super.key, required this.habitModel});

  @override
  State<UpdateHabit> createState() => _UpdateHabitState();
}

class _UpdateHabitState extends State<UpdateHabit> {
  String? title;
  int? date;
  TextEditingController? controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitsCubit, HabitsState>(
      listener: (context, state) {
        if (state is EditHabitSuccess) {
          context.read<HabitsCubit>().emitreadHabit();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              onChanged: (p0) {
                title = p0;
              },
              inputTextStyle: const TextStyle(color: Colors.white),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 107, 106, 106))),
              FoucusBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsApp.mainOrange)),
              hintText: 'Update Habit',
              hintStyle: const TextStyle(color: ColorsApp.mainOrange),
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextFormField(
              keyboardType: TextInputType.none,
              controller: controller,
              inputTextStyle: const TextStyle(color: Colors.white),
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (_) {
                      return SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 60,
                          scrollController:
                              FixedExtentScrollController(initialItem: 1),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              controller!.text = value.toString();

                              date = int.parse(controller!.text);
                            });
                          },
                          children: List<Widget>.generate(100, (index) {
                            return Center(child: Text('$index minutes'));
                          }),
                        ),
                      );
                    });
              },
              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.mainOrange)),
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                  labelText: "Select Time",
                  labelStyle: TextStyle(color: ColorsApp.mainOrange)),
              hintText: 'Time',
            ),
            const SizedBox(
              height: 10,
            ),
            const ListVeiwColorsItem(),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GTextButton(
                  text: 'Save',
                  onPressed: () {
                    widget.habitModel.habitName =
                        title ?? widget.habitModel.habitName;

                    widget.habitModel.color =
                        context.read<HabitsCubit>().color.value;

                    widget.habitModel.timeGoal =
                        date ?? widget.habitModel.timeGoal;
                    context
                        .read<HabitsCubit>()
                        .emitEditHabit(widget.habitModel.toMap());
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
