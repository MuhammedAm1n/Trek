import 'package:flutter/material.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/Todo/Widgets_Todo/AddHabit.dart';

class ProgressTodo extends StatefulWidget {
  const ProgressTodo({super.key});

  @override
  State<ProgressTodo> createState() => _ProgressTodoState();
}

class _ProgressTodoState extends State<ProgressTodo> {
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
              return AddHabit();
            });
      }),
      body: Text("MYchat"),
    );
  }
}
