class MoodModel {
  double mood;
  String path;
  DateTime date;
  List<int> why;

// List  that givin it to database to store
  List dbEntry() {
    return [mood, date.toIso8601String(), path] + why;
  }

  MoodModel(
      {required this.mood,
      required this.path,
      required this.date,
      required this.why});

  factory MoodModel.map(Map<String, dynamic> parsed) {
    // to Dont give any number expect 1 , 0 to moods
    for (int i = 0; i < 12; i++) {
      var val = parsed['r$i'];
      if (val != 1 && val != 0) {
        throw Exception("Invalid value:$val");
      }
    }

    // conidtion on mood Value
    if (parsed['mood'] == null ||
        parsed['mood'] is! double ||
        parsed['mood'] < -5 ||
        parsed['mood'] > 5) {
      throw Exception("Mood not in range");
    }

    return MoodModel(
        mood: parsed['mood'],
        path: parsed['path'],
        date: DateTime.parse(parsed['date']),
        why: [
          parsed['r0'],
          parsed['r1'],
          parsed['r2'],
          parsed['r3'],
          parsed['r4'],
          parsed['r5'],
          parsed['r6'],
          parsed['r7'],
          parsed['r8'],
          parsed['r9'],
          parsed['r10'],
          parsed['r11'],
        ]);
  }
}
