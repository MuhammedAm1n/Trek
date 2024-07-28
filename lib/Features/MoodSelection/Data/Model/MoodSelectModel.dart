class MoodModel {
  String label;
  double mood;
  String path;
  String location;
  String thumb;
  DateTime date;
  List<int> why;
  int? id;
  bool favorite;
// List  that givin it to database to store
  List dbEntry() {
    return [
          mood,
          date.toIso8601String(),
          path,
          thumb,
          label,
          location,
          favorite
        ] +
        why;
  }

  MoodModel copyWith({bool? favorite}) {
    return MoodModel(
        id: id,
        label: label,
        location: location,
        favorite: favorite ?? this.favorite,
        thumb: thumb,
        mood: mood,
        path: path,
        date: date,
        why: why);
  }

  MoodModel(
      {this.id,
      required this.thumb,
      required this.mood,
      required this.path,
      required this.date,
      required this.why,
      required this.label,
      required this.location,
      this.favorite = true});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'label': label,
      'path': path,
      'mood': mood,
      'date': date.toIso8601String(),
      'why': why.join(','), // Assuming why is a list of integers
      'thumb': thumb,
      'favorite': favorite ? 1 : 0,
    };
  }

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
      favorite: parsed["favorite"] == 1,
      location: parsed['location'],
      label: parsed['label'],
      thumb: parsed['thumb'],
      id: parsed['id'],
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
      ],
    );
  }
}
