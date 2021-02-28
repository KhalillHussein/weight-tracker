import 'dart:math';

import 'package:flutter/material.dart';

import '../models/parameters.dart';

enum WeightStatus { loseWeight, gainWeight }

class OverviewProvider with ChangeNotifier {
  final List<Parameters> _parameters = [
    Parameters(
      height: 185,
      weight: 60.12,
      age: 22,
      bmi: 18.18,
      fatPercent: 8.32,
      idealWeight: 63.32,
      date: DateTime(2021),
    ),
    Parameters(
      height: 185,
      weight: 62,
      age: 22,
      bmi: 18.12,
      fatPercent: 13.32,
      idealWeight: 63.32,
      date: DateTime(2021, 01, 05),
    ),
    Parameters(
      height: 185,
      weight: 64,
      age: 22,
      bmi: 18.7,
      fatPercent: 13.32,
      idealWeight: 63.32,
      date: DateTime(2021, 01, 09),
    ),
    Parameters(
      height: 185,
      weight: 66,
      age: 22,
      bmi: 19.28,
      fatPercent: 13.32,
      idealWeight: 52.32,
      date: DateTime.now(),
    ),
  ];

  List<Parameters> get parameters => [..._parameters];

  double get _difference => firstItem.weight - lastItem.idealWeight;
  WeightStatus _status;

  Parameters get lastItem => _parameters.last;
  Parameters get firstItem => _parameters.first;

  bool get isGainWeight => _status == WeightStatus.gainWeight;
  bool get isLoseWeight => _status == WeightStatus.loseWeight;

  int progressValue() {
    final int firstValue = firstItem.weight.round();
    final int currentValue = lastItem.weight.round();
    final position = (lastItem.weight.round() - firstItem.weight.round()).abs();
    if (_difference.isNegative) {
      _status = WeightStatus.gainWeight;
      if (currentValue < firstValue) {
        return 0;
      }
    } else if (_difference > 0) {
      _status = WeightStatus.loseWeight;
      if (currentValue > firstValue) {
        return 0;
      }
    }
    return min(position,
        (lastItem.idealWeight.round() - firstItem.weight.round()).abs());
  }

  void addData(Map<String, dynamic> map) {
    final params = Parameters.fromMap(map);
    final index = _parameters.indexWhere((e) =>
        DateTime(e.date.year, e.date.month, e.date.day) ==
        DateTime(params.date.year, params.date.month, params.date.day));
    index < 0 ? _parameters.add(params) : _parameters[index] = params;
    notifyListeners();
  }

  void removeFromList(int id) {
    _parameters
        .removeWhere((element) => element.date.millisecondsSinceEpoch == id);
    progressValue();
    notifyListeners();
  }
}
