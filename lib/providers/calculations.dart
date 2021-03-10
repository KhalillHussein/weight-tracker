import 'dart:math';

import 'package:flutter/foundation.dart';

import 'index.dart';

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier].
///
/// Класс содержит все формулы для вычисления параметров ИМТ, идеального веса, процента жира.
class CalculationsProvider with ChangeNotifier {
  //Значение текущего веса
  final double weight;
  //Значение текущего роста
  final int height;
  //Множитель выбранных единиц измерения веса
  final double units;
  //Значение текущего возраста
  final int age;
  //Значение выбранного пола
  final Gender gender;

  //Инициализируем вышеперечисленные переменные, передавая соответствующие
  //значения через конструктор
  CalculationsProvider({
    @required this.weight,
    @required this.height,
    @required this.units,
    @required this.age,
    @required this.gender,
  });

  ///формула вычисления ИМТ Адольфа Кетле
  double get bmi => weight / pow(height / 100, 2);

  ///Границы идеального веса по ИМТ
  double get idealMinWeight => 18.5 * pow(height / 100, 2);

  double get idealMaxWeight => 25 * pow(height / 100, 2);

  /// Процент жира в организме по ИМТ для мужчин
  double get maleFatPercent => 1.20 * bmi + 0.23 * age - 16.2;

  /// Процент жира в организме по ИМТ для женщин
  double get femaleFatPercent => 1.20 * bmi + 0.23 * age - 5.4;

  /// Процент жира в организме по ИМТ для мальчиков
  double get youngMaleFatPercent => 1.51 * bmi - 0.70 * age - 2.2;

  /// Процент жира в организме по ИМТ для девочек
  double get youngFemaleFatPercent => 1.51 * bmi - 0.70 * age + 1.4;

  ///Метод, возвращающий значения границ идеального веса в текстовой форме
  String idealWeightLabel() {
    final min = (idealMinWeight * units).toStringAsFixed(1);
    final max = (idealMaxWeight * units).toStringAsFixed(1);
    return '$min - $max';
  }

  ///Метод, возвращающий значения процента жира в зависимости от значений
  /// пола и возраста
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
