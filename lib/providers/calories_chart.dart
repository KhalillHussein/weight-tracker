import 'package:bmi_calculator/models/index.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CaloriesChartProvider with ChangeNotifier {
  List<Calories> calories = [];

  int _touchedIndex;

  int get touchedIndex => _touchedIndex;

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

  double get totalCal {
    return groupedValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }
}
