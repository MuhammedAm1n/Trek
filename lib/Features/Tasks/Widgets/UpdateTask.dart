import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_cubit.dart';
import 'package:video_diary/Features/Tasks/Data/Logic/cubit/task_state.dart';
import 'package:video_diary/Features/Tasks/Data/Model/HabitModel.dart';
import 'package:video_diary/Features/Tasks/Widgets/WidgetsOfAddHabit/VeiwColorsITem.dart';

class UpdateTask extends StatefulWidget {
  final TaskModel habitModel;

  const UpdateTask({super.key, required this.habitModel});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  String? title;
  int? date;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is EditTaskSucess) {
          context.read<TaskCubit>().emitReadTask();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 25),
              child: AppTextFormField(
                onChanged: (p0) {
                  title = p0;
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextFormField(
              keyboardType: TextInputType.none,
              controller: controller,
              inputTextStyle: const TextStyle(color: Colors.black),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: IconButton(
                                      onPressed: () {
                                        controller.clear();
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
                                scrollController:
                                    FixedExtentScrollController(initialItem: 1),
                                onSelectedItemChanged: (int value) {
                                  setState(() {
                                    controller.text = value.toString();

                                    date = int.parse(controller.text);
                                  });
                                },
                                children: List<Widget>.generate(100, (index) {
                                  return Center(child: Text('$index minutes'));
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
                        context.read<TaskCubit>().color.value;

                    widget.habitModel.timeGoal =
                        date ?? widget.habitModel.timeGoal;
                    context
                        .read<TaskCubit>()
                        .emitEditTask(widget.habitModel.toMap());
                    Navigator.pop(context);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
