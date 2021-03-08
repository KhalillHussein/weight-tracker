import 'package:flutter/material.dart';

import '../models/index.dart';

class ValidationProvider with ChangeNotifier {
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _count = ValidationItem(null, null);
  ValidationItem _cal = ValidationItem(null, null);

  //Getters
  ValidationItem get name => _name;
  ValidationItem get count => _count;
  ValidationItem get cal => _cal;

  bool get isValid {
    if (_name.value != null && _count.value != null && _cal.value != null) {
      return true;
    } else {
      return false;
    }
  }

  //Setters
  void changeName(String value) {
    if (value.isNotEmpty) {
      _name = ValidationItem(value, null);
    } else {
      _name = ValidationItem(null, 'Поле должно быть заполнено!');
    }
    notifyListeners();
  }

  void changeCal(String value) {
    if (num.tryParse(value) != null) {
      _cal = ValidationItem(value, null);
    } else {
      _cal = ValidationItem(null, 'Не число!');
    }
    notifyListeners();
  }

  void changeCount(String value) {
    if (int.tryParse(value) != null) {
      _count = ValidationItem(value, null);
    } else {
      _count = ValidationItem(null, 'Не число!');
    }
    notifyListeners();
  }

  num tryParse(String input) {
    final String source = input.trim();
    return int.tryParse(source) ?? double.tryParse(source);
  }
}
