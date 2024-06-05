import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Todo/Logic/cubit/habits_cubit.dart';

class AddHabit extends StatefulWidget {
  AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  TextEditingController _date = TextEditingController();

  TextEditingController _Name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitsCubit, HabitsState>(
      listener: (context, state) {
        if (state is InsertHabitSucess) {
          context.read<HabitsCubit>().emitreadHabit();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 30,
          ),
          AppTextFormField(
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 107, 106, 106))),
            FoucusBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorsApp.mainOrange)),
            hintText: 'Enter Name of Habit',
            hintStyle: TextStyle(color: ColorsApp.mainOrange),
            controller: _Name,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextFormField(
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
                            _date.text = value.toString();
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
            controller: _date,
            hintText: 'Time',
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GTextButton(
                text: 'Save',
                onPressed: () {
                  final habit = HabitModel(
                    habitName: _Name.text,
                    timeGoal: int.parse(_date.text),
                  );

                  context.read<HabitsCubit>().emitInsertHabit(habit.toMap());

                  Navigator.pop(context);
                }),
          )
        ],
      ),
    );
  }
}
