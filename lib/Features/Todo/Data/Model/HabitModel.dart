class HabitModel {
  final int? id;
  String habitName;
  int timeGoal; // Time now - Time selected
  int timeSpent;
  bool paused;

  HabitModel(
      {this.id,
      required this.habitName,
      this.timeSpent = 0,
      required this.timeGoal,
      this.paused = true});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitName': habitName,
      'timeSpent': timeSpent,
      'timeGoal': timeGoal,
      'paused': paused ? 1 : 0,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
        id: map["id"],
        habitName: map["habitName"],
        timeSpent: map["timeSpent"],
        timeGoal: map["timeGoal"],
        paused: map["paused"] == 1);
  }
}
