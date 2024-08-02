import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Logic/cubit/habit_cubit.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Widgets/WidgetsOfAddHabit/VeiwColorsITem.dart';

class AddHabit extends StatefulWidget {
  final Function(HabitModel) onHabitAdded;

  const AddHabit({super.key, required this.onHabitAdded});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final TextEditingController _time = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<HabitsCubit>().formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 25),
              child: AppTextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null; // Validation passed
                },
                inputTextStyle: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.mainColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.mainColor)),
                    labelText: "Enter Name",
                    labelStyle: TextStyle(color: ColorsApp.mainColor)),
                hintText: 'Enter Name',
                hintStyle: const TextStyle(color: ColorsApp.mainColor),
                controller: _name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: AppTextFormField(
                keyboardType: TextInputType.none,
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
                              return Center(child: Text('$index minutes'));
                            }),
                          ),
                        );
                      });
                },
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.mainColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorsApp.mainColor)),
                    icon: Icon(
                      Icons.date_range,
                      color: ColorsApp.mainColor,
                    ),
                    labelText: "Select Time",
                    labelStyle: TextStyle(color: ColorsApp.mainColor)),
                controller: _time,
                hintText: 'Time',
              ),
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
                    if (context
                        .read<HabitsCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      final habit = HabitModel(
                        habitName: _name.text,
                        timeGoal: int.parse(_time.text),
                      );
                      widget.onHabitAdded(habit);
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
