import 'package:flutter/material.dart';

class Parameters {
  final double weight;
  final int height;
  final int age;
  final double bmi;
  final double idealWeight;
  final double fatPercent;
  final DateTime date;

  const Parameters({
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
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      bmi: map['bmi'],
      idealWeight: map['idealWeight'],
      fatPercent: map['fatPercent'],
      date: map['date'],
    );
  }
}
