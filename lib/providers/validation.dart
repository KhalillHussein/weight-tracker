import 'package:flutter/material.dart';

import '../models/index.dart';

///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал проверки значений,
/// введенных с формы на странице остслеживания калорий.
class ValidationProvider with ChangeNotifier {
  //переменная, хранящая название продукта
  ValidationItem _name = ValidationItem(null, null);
  //переменная, хранящая значение количества продукта
  ValidationItem _count = ValidationItem(null, null);
  //переменная, хранящая значение количества калорий продукта
  ValidationItem _cal = ValidationItem(null, null);

  //Методы get для получения значений переменных вне класса
  ValidationItem get name => _name;
  ValidationItem get count => _count;
  ValidationItem get cal => _cal;

  ///Метод определяющий корректность заполненных данных на форме.
  ///Возаращает false, если хотя бы один из параметров указан неверно
  ///Нужен для активации/диактивации кнопки добавления данных
  bool get isValid {
    if (_name.value != null && _count.value != null && _cal.value != null) {
      return true;
    } else {
      return false;
    }
  }

  ///Метод осуществляющий проверку введенного названия продукта.
  ///Если название не указано, в объект [_name] добавляется сообщение об ошибке,
  ///а значение поля остается пустым.
  ///
  ///Если название указано, то в объект [_name] будет добавлено значение поля
  ///названия, а сообщение об ошибке создано не будет.
  void changeName(String value) {
    if (value.isNotEmpty) {
      _name = ValidationItem(value, null);
    } else {
      _name = ValidationItem(null, 'Поле должно быть заполнено!');
    }
    notifyListeners();
  }

  ///Метод осуществляющий проверку значения введенного количества калорий.
  ///Если указано не число, в объект [_cal] добавляется сообщение об ошибке,
  ///а значение поля остается пустым.
  ///
  ///Если указано число, то в объект [_cal] будет добавлено значение поля,
  ///а сообщение об ошибке создано не будет.
  void changeCal(String value) {
    if (num.tryParse(value) != null) {
      _cal = ValidationItem(value, null);
    } else {
      _cal = ValidationItem(null, 'Неверный формат числа!');
    }
    notifyListeners();
  }

  ///Метод осуществляющий проверку значения введенного количества продукта.
  ///Если указано не целое число, в объект [_count] добавляется сообщение об ошибке,
  ///а значение поля остается пустым.
  ///
  ///Если указано целое число, то в объект [_count] будет добавлено значение поля,
  ///а сообщение об ошибке создано не будет.
  void changeCount(String value) {
    if (int.tryParse(value) != null) {
      _count = ValidationItem(value, null);
    } else {
      _count = ValidationItem(null, 'Неверный формат числа!');
    }
    notifyListeners();
  }

  ///Метод в котором осуществляется преобразование строкового значения из поля
  ///формы в числовой формат. Если преобразование оказалось безуспешным,
  ///возвращает null, иначе возвращает число.
  num tryParse(String input) {
    final String source = input.trim();
    return int.tryParse(source) ?? double.tryParse(source);
  }
}
