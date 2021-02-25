import 'package:flutter/foundation.dart';

enum Period {
  all,
  month,
  twoMonths,
  threeMonths,
  year,
}

class ChipsProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Period get period => Period.values[_currentIndex];

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
