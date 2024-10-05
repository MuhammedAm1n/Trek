import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_diary/Core/Di/dependency.dart';
import 'package:video_diary/Core/Widgets/CustomSnackbar.dart';
import 'package:video_diary/Core/routing/routes.dart';
import 'package:video_diary/Core/theming/Coloring.dart';
import 'package:video_diary/Features/UploadtoDrive/Logic/cubit/gdrive_cubit.dart';
import 'package:video_diary/Features/UserPage/Logic/cubit/user_details_cubit.dart';

class DropDown extends StatelessWidget {
  const DropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          color: Colors.black,
          Icons.list,
          size: 35,
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          const DropdownMenuItem<Divider>(
              enabled: false,
              child: Divider(
                color: Colors.white,
              )),
          ...MenuItems.secondItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value! as MenuItem);
        },
        dropdownStyleData: DropdownStyleData(
          width: 130,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: ColorsApp.mainColor),
          offset: const Offset(0, 6),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
            8,
            ...List<double>.filled(MenuItems.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [settings, backup];
  static const List<MenuItem> secondItems = [logout];

  static const settings =
      MenuItem(text: 'User', icon: Icons.account_box_rounded);
  static const backup = MenuItem(text: 'Backup', icon: Icons.backup);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.settings:
        Navigator.pushNamed(context, Routes.ProfilePage);
        break;

      case MenuItems.backup:
        showDialog(
            context: context,
            builder: (context) {
              return BlocProvider(
                create: (context) => getIT<GdriveCubit>(),
                child: BlocConsumer<GdriveCubit, GdriveState>(
                  listener: (context, state) {
                    if (state is GdriveSucess) {
                      Navigator.pop(context);
                      CustomSnackbar.showSnackbar(
                          context, "Yay! Backup created.");
                    } else if (state is GdriveFaliuer) {
                      Navigator.pop(context);
                      CustomSnackbar.showSnackbar(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      icon: const Icon(
                        Icons.backup,
                        color: ColorsApp.mainColor,
                        size: 32,
                      ),
                      content: state is GdriveLoading
                          ? const LinearProgressIndicator(
                              color: ColorsApp.mainColor,
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Backup to Google Drive",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            context.read<GdriveCubit>().uploadTreks();
                          },
                          child: const Text(
                            'Got it',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            });
        break;

      case MenuItems.logout:
        logoutFire(context);
        break;
    }
  }

  static logoutFire(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      //reset user
      context.read<UserDetailsCubit>().resetUserDetails();
      // After successful logout, navigate to login screen or home screen
      Navigator.pushNamedAndRemoveUntil(context, Routes.AuthCheck,
          (route) => false); // Replace '/login' with your desired route
    } catch (e) {
      rethrow;
      // Handle error if logout fails
    }
  }
}
