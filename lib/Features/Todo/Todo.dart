import 'package:flutter/material.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class ProgressTodo extends StatelessWidget {
  const ProgressTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress ToDo'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(
            backgroundColor: ColorsApp.darkGrey,
            context: context,
            builder: (context) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFormField(
                    hintText: 'Enter Name of Habit',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: ColorsApp.mainOrange),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextFormField(
                      hintText: 'Time',
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: ColorsApp.mainOrange),
                          borderRadius: BorderRadius.circular(16)))
                ],
              );
            });
      }),
      body: Text("MYchat"),
    );
  }
}
