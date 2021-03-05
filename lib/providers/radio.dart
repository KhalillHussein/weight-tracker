///Импорт необходимых модулей для класса [RadioProvider]
///Модуль [shared_preferences] добавляет возможность сохранения информации
///о выбранных настройках на локальном хранилище устройства пользователя.
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

///"Перечисление" в котором указаны все доступные единицы измерения роста
enum MeasureHeight {
  centimeters,
  footInches,
}

///"Перечисление" в котором указаны все доступные единицы измерения веса
enum MeasureWeight {
  kilograms,
  pounds,
}

///"Перечисление" в котором указаны все доступные величины, которые можно
///отобразить на графике
enum GraphType {
  weight,
  fatPercent,
  bmi,
}

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал меню "Настройки"
class RadioProvider with ChangeNotifier {
  //Конструктор текущего класса, в котором выполняется вызов метода инициализации
  RadioProvider() {
    init();
  }
  //Переменная, хранящая значение единиц измерения роста
  MeasureHeight _measureHeight = MeasureHeight.centimeters;
  //Переменная, хранящая значение единиц измерения веса
  MeasureWeight _measureWeight = MeasureWeight.kilograms;
  //Переменная, хранящая значение соответствующее выбранному графику
  GraphType _graphType = GraphType.weight;

  //Методы get для получения значений переменных из других классов
  MeasureHeight get currentHeightMeasure => _measureHeight;
  MeasureWeight get currentWeightMeasure => _measureWeight;
  GraphType get currentGraphType => _graphType;

  //Далее приведены методы set, используемые для изменения значений переменных
  //на значения, указанные пользователем. С помощью вызова метода [notifyListeners]
  //обновляем преставление.
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

  /// Асинхронный метод для инициализации данных. В нем выполняется загрузка данных
  /// из локального хранилища устройства с помощью модуля [SharedPreferences]
  /// или при их отстуствии инициализация значений по умолчанию.
  Future<void> init() async {
    //загрузка и парсинг данных из локального хранилища
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      //присваиваем переменным значения, полученные из локального хранилища
      _measureHeight = MeasureHeight.values[prefs.getInt('heightMeasure')];
      _measureWeight = MeasureWeight.values[prefs.getInt('weightMeasure')];
      _graphType = GraphType.values[prefs.getInt('chartType')];
    } catch (e) {
      //Произошла ошибка, выполняем запись значений по умолчанию
      prefs.setInt(
          'heightMeasure', MeasureHeight.values.indexOf(_measureHeight));
      prefs.setInt(
          'heightMeasure', MeasureWeight.values.indexOf(_measureWeight));
      prefs.setInt('chartType', GraphType.values.indexOf(_graphType));
    }
    notifyListeners();
  }

  ///Метод для создания ассоциативных массивов, которые являются интерпретацией
  ///выбранных пунктов единиц измерения веса в настройках.
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

  ///Метод для создания ассоциативных массивов, которые являются интерпретацией
  ///выбранных пунктов единиц измерения роста в настройках.
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

  ///Метод для создания ассоциативных массивов, которые являются интерпретацией
  ///выбранных пунктов вида графика в настройках.
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
