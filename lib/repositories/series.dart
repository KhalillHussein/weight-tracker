import 'dart:math';

import 'package:bmi_calculator/providers/chips.dart';
import 'package:bmi_calculator/providers/radio.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/parameters.dart';

class Series {
  final List<Parameters> data;
  final Period period;
  final GraphType type;

  Series({this.data, this.period, this.type}) {
    chartType();
    prepareData();
  }

  double _minY = 0;
  double _maxY = 0;
  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  double leftTitlesInterval;
  double bottomTitlesInterval;
  final int _divider = 8;

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

  List<FlSpot> get spotsBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.bmi,
        );
      }).toList();

  List<FlSpot> get spotsFatPercent => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.fatPercent,
        );
      }).toList();

  double scale() {
    switch (period) {
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

  List<FlSpot> chartType() {
    switch (type) {
      case GraphType.weight:
        {
          _minY = [...spotsCurrentWeight, ...spotsIdealWeight]
              .map((e) => e.y)
              .reduce(min);
          _maxY = [...spotsCurrentWeight, ...spotsIdealWeight]
              .map((e) => e.y)
              .reduce(max);
          return spotsCurrentWeight;
        }
        break;
      case GraphType.fatPercent:
        {
          _minY = [...spotsFatPercent].map((e) => e.y).reduce(min);
          _maxY = [...spotsFatPercent].map((e) => e.y).reduce(max);
          return spotsFatPercent;
        }
        break;
      case GraphType.bmi:
        {
          _minY = [...spotsBMI].map((e) => e.y).reduce(min);
          _maxY = [...spotsBMI].map((e) => e.y).reduce(max);
          return spotsBMI;
        }
        break;
      default:
        {
          _minY = [...spotsCurrentWeight, ...spotsIdealWeight]
              .map((e) => e.y)
              .reduce(min);
          _maxY = [...spotsCurrentWeight, ...spotsIdealWeight]
              .map((e) => e.y)
              .reduce(max);
          return spotsCurrentWeight;
        }
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

    minY = (_minY / _divider).floorToDouble() * _divider;
    maxY = (_maxY / _divider).ceilToDouble() * _divider;

    leftTitlesInterval = max(((maxY - minY) / 3).floorToDouble(), 1);
    bottomTitlesInterval = (maxX - minX) / 4;
  }
}
