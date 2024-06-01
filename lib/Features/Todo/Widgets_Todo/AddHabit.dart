import 'package:flutter/material.dart';
import 'package:video_diary/Core/Widgets/TextButton.dart';
import 'package:video_diary/Core/Widgets/TextFormField.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

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
    return Column(
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
          onTap: () async {
            await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    barrierColor: ColorsApp.darkGrey)
                .then((value) {
              setState(() {
                _date.text = value!.format(context).toString();
              });
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
          padding: const EdgeInsets.all(50.0),
          child: GTextButton(
              text: 'Save',
              onPressed: () {
                Navigator.pop(context);
              }),
        )
      ],
    );
  }
}
