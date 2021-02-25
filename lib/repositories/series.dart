import 'dart:math';

import 'package:bmi_calculator/providers/chips.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/parameters.dart';

class Series {
  final List<Parameters> data;
  final Period _period;

  Series(this.data, this._period) {
    prepareData();
  }

  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  double leftTitlesInterval;
  double bottomTitlesInterval;
  final int _divider = 1;

  double get avgWeight =>
      data.map((e) => e.weight).reduce((a, b) => a + b) / data.length;

  List<FlSpot> get spotsCurrentWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.weight,
        );
      }).toList();

  List<FlSpot> get spotsIdealWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.idealWeight,
        );
      }).toList();

  List<FlSpot> get spotsAvgWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          avgWeight,
        );
      }).toList();

  double get _minY =>
      [...spotsCurrentWeight, ...spotsIdealWeight].map((e) => e.y).reduce(min);
  double get _maxY =>
      [...spotsCurrentWeight, ...spotsIdealWeight].map((e) => e.y).reduce(max);

  double scale() {
    switch (_period) {
      case Period.all:
        return spotsCurrentWeight.last.x;
        break;
      case Period.month:
        return spotsCurrentWeight.first.x + Duration(days: 30).inMilliseconds;
        break;
      case Period.twoMonths:
        return spotsCurrentWeight.first.x + Duration(days: 60).inMilliseconds;
        break;
      case Period.threeMonths:
        return spotsCurrentWeight.first.x + Duration(days: 90).inMilliseconds;
        break;
      case Period.year:
        return spotsCurrentWeight.first.x + Duration(days: 365).inMilliseconds;
        break;
      default:
        return spotsCurrentWeight.last.x;
        break;
    }
  }

  void prepareData() {
    minX = spotsCurrentWeight.first.x == spotsCurrentWeight.last.x
        ? spotsCurrentWeight.last.x - Duration(hours: 3).inMilliseconds
        : spotsCurrentWeight.first.x;
    maxX = spotsCurrentWeight.first.x == spotsCurrentWeight.last.x
        ? spotsCurrentWeight.last.x + Duration(hours: 3).inMilliseconds
        : scale();

    debugPrint('minX is: $minX, maxX is: $maxX');
    minY = (_minY / _divider).floorToDouble() * _divider;
    maxY = (_maxY / _divider).ceilToDouble() * _divider;
    debugPrint('minY is: $minY, maxY is: $maxY');

    leftTitlesInterval = max(((maxY - minY) / 3).floorToDouble(), 1);
    debugPrint('leftTitlesInterval: $leftTitlesInterval');
    bottomTitlesInterval = (maxX - minX) / 4;
    debugPrint('bottomTitlesInterval: $bottomTitlesInterval');
  }
}
