import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

import 'package:video_diary/Features/Snippets/Logic/cubit/reminder_cubit.dart';

class SnippetsPage extends StatefulWidget {
  const SnippetsPage({super.key});

  @override
  State<SnippetsPage> createState() => _SnippetsPageState();
}

class _SnippetsPageState extends State<SnippetsPage> {
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: ColorsApp.backGround,
        backgroundColor: ColorsApp.backGround,
        shadowColor: ColorsApp.mediumGrey,
        elevation: 1,
        toolbarHeight: 90,
        title: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Image.asset(
            "assets/images/Snippets.png",
            scale: 20,
          ),
        ),
        actions: [
          Transform.scale(
            scaleX: -1,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/images/arrow3.png",
                scale: 28,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: context.read<ReminderCubit>().getReminder(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final posts = snapshot.data?.docs ?? [];
                if (posts.isEmpty) {
                  return const Center(child: Text('No Snippet.. Wait for it!'));
                }
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String message = post['PostMessage'];
                    Timestamp timestamp = post['TimeStamp'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        "${dateTime.day} / ${dateTime.month}";
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15.0, right: 15, bottom: 15),
                      child: ListTile(
                        shape: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: ColorsApp.mainColor),
                            borderRadius: BorderRadius.circular(20)),
                        iconColor: Colors.black,
                        title: Text(message),
                        subtitle: Text(
                          formattedDate,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Share.share(message);
                            },
                            icon: Icon(UniconsLine.share)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
