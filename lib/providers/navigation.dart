import 'package:flutter/foundation.dart';


///Один из классов, реализующий шаблон проектирования [Provider].
///С помощью ключевого слова [with] добавляем возможность использовать свойства
///класса [ChangeNotifier]. С помощью вызова метода [notifyListeners] будет
///произведено обновление представления при изменении данных в текущем классе.
///
/// Класс реализующий функционал навигации между страницами приложения
class NavigationProvider with ChangeNotifier {
  //Переменная, хранящая индекс текущей страницы
  int _currentIndex = 0;

  //Метод get для получения индекса вне текущего класса
  int get currentIndex => _currentIndex;

  ///Метод set, используемый для изменения значения индекса страницы на значение
  ///страницы, выбранной пользователем. С помощью вызова метода [notifyListeners]
  ///обновляем преставление
  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
