import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> moodFilter = [
    "Super Great",
    "Pretty well",
    "Completely Fine",
    "Somewhat Bad",
    "Totally Terrible"
  ];

  List<String> selectedMood = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: moodFilter
                      .map((mood) => FilterChip(
                          selected: selectedMood.contains(mood),
                          label: Text(mood),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedMood.add(mood);
                              } else {
                                selectedMood.remove(mood);
                              }
                            });
                          }))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
