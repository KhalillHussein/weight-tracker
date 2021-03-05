import 'package:flutter/foundation.dart';

import 'index.dart';

///"Перечисление" в котором указаны варианты выбора пола
enum Gender {
  male,
  female,
}

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал ввода данных на экране ввода
class InputProvider with ChangeNotifier {
  //Переменная, которая хранит значение единиц измерения роста
  final MeasureHeight currentHeightMeasure;
  //Переменная, которая хранит значение единиц измерения веса
  final MeasureWeight currentWeightMeasure;
  //Переменная, которая хранит множитель единиц измерения веса
  final double weightUnit;

  //Конструктор текущего класса. При создании экземпляра данного класса,
  //в него будут переданы параметры для инициализации переменных.
  InputProvider({
    @required this.currentHeightMeasure,
    @required this.currentWeightMeasure,
    @required this.weightUnit,
  });

  //Переменная, хранящая значение пола
  Gender gender = Gender.male;
  //Приватная переменная, хранящая значение роста
  int _height = 180;
  //Приватная переменная, хранящая значение веса
  int _weight = 60;
  //Приватная переменная, хранящая значение возраса
  int _age = 20;

  //Геттеры для получения значения переменных вне текущего класса
  int get minHeight => 120;

  int get maxHeight => 220;

  int get height => _height;

  int get weight => _weight;

  int get age => _age;

  //Далее приведены методы, используемые для изменения значений переменных
  //на значения, указанные пользователем. С помощью вызова метода [notifyListeners]
  //обновляем преставление.

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
    gender = currentGender;
    notifyListeners();
  }

  ///Метод возвращающий значение роста в выбранной системе единиц
  String labelHeight() {
    switch (currentHeightMeasure) {
      case MeasureHeight.centimeters:
        return '$_height';
        break;
      case MeasureHeight.footInches:
        return convertedCmToFeet();
        break;
      default:
        return 'none';
        break;
    }
  }

  ///Метод, преобразующий сантиметры в футы/дюймы
  String convertedCmToFeet() {
    final double realFeet = (_height * 0.393701) / 12;
    final int feet = realFeet.floor();
    final int inches = ((realFeet - feet) * 12).round();
    return '$feet\'$inches"';
  }

  ///Метод возвращающий значение веса в выбранной системе единиц
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

  ///Метод, преобразующий килограммы в фунты
  String convertedKgToLbs() {
    final int toLbs = (_weight * weightUnit).round();
    return "$toLbs";
  }
}
