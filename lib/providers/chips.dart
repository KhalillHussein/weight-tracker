import 'package:flutter/foundation.dart';

///"Перечисление" в котором указаны периоды времени для масштабирования графика
enum Period {
  all,
  month,
  twoMonths,
  threeMonths,
  year,
}

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал изменения масштаба верстки графика
class ChipsProvider with ChangeNotifier {
  //инициализация значения индекса(по умолчанию выбран 1 элемент)
  int _currentIndex = 0;

  ///Метод get для получения текущего индекса выбранного элемента
  int get currentIndex => _currentIndex;

  ///Метод get для определения индекса выбранного периода
  Period get period => Period.values[_currentIndex];

  ///Метод set, используемый для изменения значения индекса на значение,
  ///указанное пользователем. С помощью вызова метода [notifyListeners]
  ///обновляем преставление
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
