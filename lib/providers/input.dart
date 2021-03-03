import 'package:bmi_calculator/providers/radio.dart';
import 'package:flutter/foundation.dart';

enum Gender {
  male,
  female,
}

class InputProvider with ChangeNotifier {
  final MeasureHeight currentHeightMeasure;
  final MeasureWeight currentWeightMeasure;
  final double weightUnit;

  InputProvider({
    @required this.currentHeightMeasure,
    @required this.currentWeightMeasure,
    @required this.weightUnit,
  });

  Gender selectedGender = Gender.male;
  int _height = 180;
  int _weight = 60;
  int _age = 20;

  int get minHeight => 120;

  int get maxHeight => 220;

  int get height => _height;

  int get weight => _weight;

  int get age => _age;

  set height(int newHeight) {
    _height = newHeight;
    notifyListeners();
  }

  void incrementWeight() {
    _weight++;
    notifyListeners();
  }

  void decrementWeight() {
    _weight--;
    notifyListeners();
  }

  void incrementAge() {
    _age++;
    notifyListeners();
  }

  void decrementAge() {
    _age--;
    notifyListeners();
  }

  void setGender(Gender currentGender) {
    selectedGender = currentGender;
    notifyListeners();
  }

  String labelHeight() {
    switch (currentHeightMeasure) {
      case MeasureHeight.centimeters:
        return '$_height';
        break;
      case MeasureHeight.footInches:
        return convertedCentToFeet();
        break;
      default:
        return 'none';
        break;
    }
  }

  String convertedCentToFeet() {
    final double realFeet = (_height * 0.393701) / 12;
    final int feet = realFeet.floor();
    final int inches = ((realFeet - feet) * 12).round();
    return '$feet\'$inches"';
  }

  String labelWeight() {
    switch (currentWeightMeasure) {
      case MeasureWeight.kilograms:
        return '$_weight';
        break;
      case MeasureWeight.pounds:
        return convertedKgToLbs();
        break;
      default:
        return 'none';
        break;
    }
  }

  String convertedKgToLbs() {
    final int toLbs = (_weight * weightUnit).round();
    return "$toLbs";
  }
}
