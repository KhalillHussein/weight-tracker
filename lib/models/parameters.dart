import 'package:flutter/foundation.dart';

///Класс, реализующий модель, для хранения данных измерений пользователя.
class Parameters {
  final int id;
  final double weight;
  final int height;
  final int age;
  final double bmi;
  final double idealWeight;
  final double fatPercent;
  final DateTime date;

  const Parameters({
    @required this.id,
    @required this.weight,
    @required this.height,
    @required this.age,
    @required this.bmi,
    @required this.date,
    @required this.fatPercent,
    @required this.idealWeight,
  });

  factory Parameters.fromMap(Map<String, dynamic> map) {
    return Parameters(
      id: map['id'],
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      bmi: map['bmi'],
      idealWeight: map['idealWeight'],
      fatPercent: map['fatPercent'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }
}
