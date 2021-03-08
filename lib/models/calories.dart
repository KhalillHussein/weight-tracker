class Calories {
  final int id;
  final String name;
  final int count;
  final double calories;
  final DateTime date;

  Calories({
    this.id,
    this.name,
    this.count,
    this.calories,
    this.date,
  });

  factory Calories.fromMap(Map<String, dynamic> map) {
    return Calories(
      id: map['id'],
      name: map['name'],
      count: map['count'],
      calories: map['calories'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
