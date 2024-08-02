class HabitModel {
  static int _idCounter =
      0; // static variable to keep track of the highest ID used

  final int id;
  int? color;
  String habitName;
  int timeGoal; // Time now - Time selected
  int timeSpent;
  bool paused;

  HabitModel({
    int? id,
    this.color,
    required this.habitName,
    this.timeSpent = 0,
    required this.timeGoal,
    this.paused = true,
  }) : id = id ?? _incrementId();

  static int _incrementId() {
    return ++_idCounter;
  }

  HabitModel copyWith({
    int? id,
    int? color,
    String? habitName,
    int? timeGoal,
    int? timeSpent,
    bool? paused,
  }) {
    return HabitModel(
      id: id ?? this.id,
      color: color ?? this.color,
      habitName: habitName ?? this.habitName,
      timeGoal: timeGoal ?? this.timeGoal,
      timeSpent: timeSpent ?? this.timeSpent,
      paused: paused ?? this.paused,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'habitName': habitName,
      'timeSpent': timeSpent,
      'timeGoal': timeGoal,
      'paused': paused ? 1 : 0,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      color: map['color'],
      habitName: map['habitName'],
      timeSpent: map['timeSpent'],
      timeGoal: map['timeGoal'],
      paused: map['paused'] == 1,
    );
  }
}
