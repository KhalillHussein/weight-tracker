import 'dart:math';

import 'package:bmi_calculator/providers/index.dart';

class Calculations {
  final double weight;
  final int height;
  final int age;
  final Gender gender;

  const Calculations({
    this.weight,
    this.height,
    this.age,
    this.gender,
  });

  double get bmi => weight / pow(height / 100, 2);

  double get idealMinWeight => 18.5 * pow(height / 100, 2);

  double get idealMaxWeight => 25 * pow(height / 100, 2);

  double get maleFatPercent => 1.20 * bmi + 0.23 * age - 16.2;

  double get femaleFatPercent => 1.20 * bmi + 0.23 * age - 5.4;

  double get youngMaleFatPercent => 1.51 * bmi - 0.70 * age - 2.2;

  double get youngFemaleFatPercent => 1.51 * bmi - 0.70 * age + 1.4;

  double getFatPercent() {
    switch (gender) {
      case Gender.male:
        if (age < 18) {
          return youngMaleFatPercent;
        } else {
          return maleFatPercent;
        }
        break;
      case Gender.female:
        if (age < 18) {
          return youngFemaleFatPercent;
        } else {
          return femaleFatPercent;
        }
        break;
      default:
        return 0.0;
        break;
    }
  }
}
