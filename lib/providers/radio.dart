import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MeasureHeight {
  centimeters,
  footInches,
}

enum MeasureWeight {
  kilograms,
  pounds,
}

enum GraphType {
  weight,
  fatPercent,
  bmi,
}

class RadioProvider with ChangeNotifier {
  RadioProvider() {
    init();
  }

  MeasureHeight _measureHeight = MeasureHeight.centimeters;
  MeasureWeight _measureWeight = MeasureWeight.kilograms;
  GraphType _graphType = GraphType.weight;

  MeasureHeight get currentHeightMeasure => _measureHeight;

  MeasureWeight get currentWeightMeasure => _measureWeight;

  GraphType get currentGraphType => _graphType;

  set currentHeightMeasure(MeasureHeight newMeasure) {
    _measureHeight = newMeasure;
    notifyListeners();
  }

  set currentWeightMeasure(MeasureWeight newMeasure) {
    _measureWeight = newMeasure;
    notifyListeners();
  }

  set currentGraphType(GraphType newGraphType) {
    _graphType = newGraphType;
    notifyListeners();
  }

  /// Load settings information from local storage
  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _measureHeight = MeasureHeight.values[prefs.getInt('heightMeasure')];
      _measureWeight = MeasureWeight.values[prefs.getInt('weightMeasure')];
      _graphType = GraphType.values[prefs.getInt('chartType')];
    } catch (e) {
      prefs.setInt(
          'heightMeasure', MeasureHeight.values.indexOf(_measureHeight));
      prefs.setInt(
          'heightMeasure', MeasureWeight.values.indexOf(_measureWeight));
      prefs.setInt('chartType', GraphType.values.indexOf(_graphType));
    }
    notifyListeners();
  }

  Map<String, dynamic> getMeasureWeightInterpretation() {
    switch (_measureWeight) {
      case MeasureWeight.kilograms:
        return {'interpretation': 'Килограммы', 'abbr': 'kg', 'unit': 1.0};
        break;
      case MeasureWeight.pounds:
        return {
          'interpretation': 'Фунты',
          'abbr': 'lbs',
          'unit': 1 / 0.45359237
        };
        break;
      default:
        return {'interpretation': 'Неизвестно', 'abbr': 'none', 'unit': 0.0};
        break;
    }
  }

  Map<String, dynamic> getMeasureHeightInterpretation() {
    switch (_measureHeight) {
      case MeasureHeight.centimeters:
        return {'interpretation': 'Сантиметры', 'abbr': 'cm'};
        break;
      case MeasureHeight.footInches:
        return {'interpretation': 'Футы/дюймы', 'abbr': ''};
        break;
      default:
        return {'interpretation': 'Неизвестно', 'abbr': 'none'};
        break;
    }
  }

  Map<String, dynamic> getGraphTypeInterpretation() {
    switch (_graphType) {
      case GraphType.weight:
        return {'name': 'Вес', 'units': getMeasureWeightInterpretation()};
        break;
      case GraphType.fatPercent:
        return {
          'name': 'Процент жира',
          'units': {'abbr': '%'}
        };
        break;
      case GraphType.bmi:
        return {
          'name': 'ИМТ',
          'units': {'abbr': 'kg/m2'}
        };
        break;
      default:
        return {
          'name': 'Неизвестно',
          'units': {'abbr': ''}
        };
        break;
    }
  }
}
