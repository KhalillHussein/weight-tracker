import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/index.dart';

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал диаграммы калорий.
class CaloriesChartProvider with ChangeNotifier {
  //массив элементов типа Calories, каждый элемент хранит введенные данные
  List<Calories> calories = [];

  //индекс выбранной нажатием шкалы диаграммы
  int _touchedIndex;

  //Метод get для получения индекса выбранной шкалы из других классов
  int get touchedIndex => _touchedIndex;

  ///Метод реализующий присваивание переменной нового индекса выбранной шкалы
  void setTouchedIndex(BarTouchResponse barTouchResponse) {
    if (barTouchResponse.spot != null &&
        barTouchResponse.touchInput is! FlPanEnd &&
        barTouchResponse.touchInput is! FlLongPressEnd) {
      _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
    } else {
      _touchedIndex = -1;
    }
    notifyListeners();
  }

  ///Метод get, в котором выполняется создание списка ассоциативных массивов
  ///для шкал для диаграммы. Всего будет создано 7 элементов массива, для 7 дней
  ///недели. Каждый элемент содержит два атрибута: День недели по оси X,
  ///Суммарное кол-во калорий по оси Y, потребленных в этот день.
  List<Map<String, Object>> get groupedValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (int i = 0; i < calories.length; i++) {
        if (calories[i].date.day == weekDay.day &&
            calories[i].date.month == weekDay.month &&
            calories[i].date.year == weekDay.year) {
          totalSum += calories[i].calories;
        }
      }
      return {
        'day': toBeginningOfSentenceCase(DateFormat.E('Ru').format(weekDay)),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  ///Метод get, возвращающий суммарную величину колорий списка [groupedValues]
  ///он необходим для определения точки максимума по оси Y на диаграмме
  double get totalCal {
    return groupedValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }
}
