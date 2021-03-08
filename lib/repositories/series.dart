///Импорт необходимых модулей для класса [Series]
///Модуль [fl_chart] добавляет возможность визуализации данных в виде графика.
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import '../models/parameters.dart';
import './../providers/index.dart';

///Класс реализующий создание точек на графике.
class Series {
  //Переменная, хранящая массив данных типа Parameters.
  final List<Parameters> data;
  //Переменная хранящая значение выбранного периода времени
  final Period period;
  //Переменная, хранящая значение выбранного графика
  final GraphType type;

  //Конструктор текущего класса, с параметрами, инициализируемыми при создании
  //экземпляра текущего класса
  Series({this.data, this.period, this.type}) {
    chartType();
    prepareData();
  }

  //Переменная, хранящая начальное значение минимума по оси Y
  double _minY = 0;
  //Переменная, хранящая начальное значение максимума по оси Y
  double _maxY = 0;
  //Переменная, хранящая итоговое значение минимума по оси X
  double minX = 0;
  //Переменная, хранящая итоговое значение максимума по оси X
  double maxX = 0;
  //Переменная, хранящая итоговое значение минимума по оси Y
  double minY = 0;
  //Переменная, хранящая итоговое значение максимума по оси Y
  double maxY = 0;

  //Переменная, хранящая значение интервала делений по вертикали
  double leftTitlesInterval;
  //Переменная, хранящая значение интервала делений по горизонтали
  double bottomTitlesInterval;

  //Переменная, задающая интервал делений по вертикали
  final int _divider = 8;

  //Метод get, в котором определяется среднее значение веса
  double get avgWeight =>
      data.map((e) => e.weight).reduce((a, b) => a + b) / data.length;

  //Метод get, создающий массив точек для графика текущего веса
  List<FlSpot> get spotsCurrentWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.weight,
        );
      }).toList();

  //Метод get, создающий массив точек для графика иделального веса
  List<FlSpot> get spotsIdealWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.idealWeight,
        );
      }).toList();

  //Метод get, создающий массив точек для графика среднего веса
  List<FlSpot> get spotsAvgWeight => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          avgWeight,
        );
      }).toList();

  //Методы get, создающие массив точек для графиков ИМТ
  List<FlSpot> get spotsBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.bmi,
        );
      }).toList();

  List<FlSpot> get spotsUWBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          18.5,
        );
      }).toList();

  List<FlSpot> get spotsNormalBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          25.0,
        );
      }).toList();

  List<FlSpot> get spotsOverweightBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          30.0,
        );
      }).toList();

  List<FlSpot> get spotsObeseBMI => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          35.0,
        );
      }).toList();

  //Метод get, создающий массив точек для графика процента жира
  List<FlSpot> get spotsFatPercent => data.map((e) {
        return FlSpot(
          e.date.millisecondsSinceEpoch.toDouble(),
          e.fatPercent,
        );
      }).toList();

  ///Метод, возвращающий значение максимума в миллисекундах для оси X
  ///Значение максимума зависит от выбранного масштаба верстки: месяц, 2 месяца...
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

  ///Метод, возвращающий массив точек в зависимости от выбранного типа графика
  ///Он также устанавливает начальные значения для минимума и максимума по оси Y.
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
          _minY = [...spotsBMI, ...spotsUWBMI].map((e) => e.y).reduce(min);
          _maxY = [...spotsBMI, ...spotsObeseBMI].map((e) => e.y).reduce(max);
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

  ///Метод в котором реализуется определение конечных значений минимумов
  ///и максимумов по осям X и Y.
  void prepareData() {
    //определяем значение минимума и максимума по оси X.
    //Если значения начальной и конечной точки по оси X совпадут, то сдвигаем
    //значение конечной точки на указанный период (3 часа).
    minX = spotsCurrentWeight.first.x == spotsCurrentWeight.last.x
        ? spotsCurrentWeight.last.x - Duration(hours: 3).inMilliseconds
        : spotsCurrentWeight.first.x;
    maxX = spotsCurrentWeight.first.x == spotsCurrentWeight.last.x
        ? spotsCurrentWeight.last.x + Duration(hours: 3).inMilliseconds
        : scale();

    //определяем конечное значение минимума и максимума по оси Y.
    //
    minY = (_minY / _divider).floorToDouble() * _divider;
    maxY = (_maxY / _divider).ceilToDouble() * _divider;

    //Определяем интервал точек по оси Y
    leftTitlesInterval = max(((maxY - minY) / 3).floorToDouble(), 1);

    //Определяем интевал точек по оси X
    bottomTitlesInterval = (maxX - minX) / 4;
  }
}
