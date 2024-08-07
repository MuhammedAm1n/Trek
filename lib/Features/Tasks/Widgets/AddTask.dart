import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_cubit.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Tasks/Widgets/WidgetsOfAddHabit/VeiwColorsITem.dart';

class AddTask extends StatefulWidget {
  final Function(TaskModel) onHabitAdded;

  const AddTask({super.key, required this.onHabitAdded});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _time = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<TaskCubit>().formKey,
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: IconButton(
                                        onPressed: () {
                                          _time.clear();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.cancel)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.check)),
                                  )
                                ],
                              ),
                            ),
                            Stack(children: [
                              SizedBox(
                                height: 250,
                                width: double.infinity,
                                child: CupertinoPicker(
                                  backgroundColor: Colors.white,
                                  itemExtent: 60,
                                  scrollController: FixedExtentScrollController(
                                      initialItem: 0),
                                  onSelectedItemChanged: (int value) {
                                    setState(() {
                                      _time.text = value.toString();
                                    });
                                  },
                                  children: List<Widget>.generate(100, (index) {
                                    return Center(
                                        child: Text('$index minutes'));
                                  }),
                                ),
                              ),
                            ]),
                          ],
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
                        .read<TaskCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      final habit = TaskModel(
                        habitName: _name.text,
                        timeGoal: int.parse(_time.text),
                      );
                      widget.onHabitAdded(habit);
                      context.read<TaskCubit>().emitInsertTask(habit);
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
