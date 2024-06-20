import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_state.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Widgets/WidgetsOfAddHabit/ColorItem.dart';
import 'package:video_diary/Features/Todo/Widgets/WidgetsOfAddHabit/VeiwColorsITem.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final TextEditingController _time = TextEditingController();
  final TextEditingController _name = TextEditingController();
  List colors = [Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitsCubit, HabitsState>(
      listener: (context, state) {
        if (state is InsertHabitSucess) {
          context.read<HabitsCubit>().emitreadHabit();
        }
      },
      child: Form(
        key: context.read<HabitsCubit>().formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
            ),
            AppTextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a habit name';
                }
                return null; // Validation passed
              },
              inputTextStyle: const TextStyle(color: Colors.black),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 107, 106, 106))),
              FoucusBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsApp.mainOrange)),
              hintText: 'Enter Name of Habit',
              hintStyle: const TextStyle(color: ColorsApp.mainOrange),
              controller: _name,
            ),
            const SizedBox(
              height: 20,
            ),
            AppTextFormField(
              inputTextStyle: const TextStyle(color: Colors.black),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Time';
                }
              },
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
                              _time.text = value.toString();
                            });
                          },
                          children: List<Widget>.generate(100, (index) {
                            return Center(child: Text('${index} minutes'));
                          }),
                        ),
                      );
                    });
              },
              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorsApp.mainOrange)),
                  icon: Icon(Icons.date_range),
                  labelText: "Select Time",
                  labelStyle: TextStyle(color: ColorsApp.mainOrange)),
              controller: _time,
              hintText: 'Time',
            ),
            const SizedBox(
              height: 20,
            ),
            const ListVeiwColorsItem(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GTextButton(
                  text: 'Save',
                  onPressed: () {
                    if (context
                        .read<HabitsCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      final habit = HabitModel(
                        habitName: _name.text,
                        timeGoal: int.parse(_time.text),
                      );
                      context.read<HabitsCubit>().emitInsertHabit(habit);
                      Navigator.pop(context);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
