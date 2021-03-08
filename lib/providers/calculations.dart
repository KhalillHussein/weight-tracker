import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:bmi_calculator/providers/index.dart';

class CalculationsProvider with ChangeNotifier {
  final double weight;
  final int height;
  final double units;
  final int age;
  final Gender gender;

  CalculationsProvider({
    @required this.weight,
    @required this.height,
    @required this.units,
    @required this.age,
    @required this.gender,
  });

  double get bmi => weight / pow(height / 100, 2);

  double get idealMinWeight => 18.5 * pow(height / 100, 2);

  double get idealMaxWeight => 25 * pow(height / 100, 2);

  double get maleFatPercent => 1.20 * bmi + 0.23 * age - 16.2;

  double get femaleFatPercent => 1.20 * bmi + 0.23 * age - 5.4;

  double get youngMaleFatPercent => 1.51 * bmi - 0.70 * age - 2.2;

  double get youngFemaleFatPercent => 1.51 * bmi - 0.70 * age + 1.4;

  double get heartRateFemale => 190.2 / (1 + exp(0.0453 * (age - 107.5)));

  double get heartRateMale => 203.7 / (1 + exp(0.033 * (age - 104.3)));

  double getHeartRateByGender() {
    switch (gender) {
      case Gender.male:
        return heartRateMale;
        break;
      case Gender.female:
        return heartRateFemale;
        break;
      default:
        return 0.0;
        break;
    }
  }

  String idealWeightLabel() {
    final min = (idealMinWeight * units).toStringAsFixed(1);
    final max = (idealMaxWeight * units).toStringAsFixed(1);
    return '$min - $max';
  }

  double percentOfHeartRate(int percent) {
    return getHeartRateByGender() * (percent / 100);
  }

  double getFatPercentByGender() {
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
