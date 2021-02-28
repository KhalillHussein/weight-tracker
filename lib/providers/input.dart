import 'package:flutter/foundation.dart';

enum Gender {
  male,
  female,
}

class InputProvider with ChangeNotifier {
  Gender selectedGender = Gender.male;
  int _height = 180;
  double _weight = 60;
  int _age = 20;

  int get height => _height;

  double get weight => _weight;

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
}
