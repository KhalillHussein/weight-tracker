import 'dart:math';

import 'package:bmi_calculator/helpers/db_helper.dart';
import 'package:bmi_calculator/providers/base.dart';

import '../models/parameters.dart';

enum WeightStatus { loseWeight, gainWeight }

class OverviewProvider extends BaseRepository<Parameters> {
  double weightUnit = 1.0;

  WeightStatus _status;

  List<Parameters> _parameters = [];

  @override
  List<Parameters> get parameters => [..._parameters];

  @override
  Future<void> loadData() async {
    final loadedData = await DBHelper.db.getData();
    finishLoading();
    _parameters = [for (final item in loadedData) Parameters.fromMap(item)];
    _parameters = [
      for (final item in _parameters)
        Parameters(
          id: item.id,
          weight: item.weight * weightUnit,
          height: item.height,
          age: item.age,
          bmi: item.bmi,
          date: item.date,
          fatPercent: item.fatPercent,
          idealWeight: item.idealWeight * weightUnit,
        )
    ];
  }

  @override
  Future<void> addData(Map<String, dynamic> map) async {
    startLoading();
    await DBHelper.db.insert(map);
    loadData();
  }

  @override
  void deleteData(int id) {
    DBHelper.db.deleteItem(id);
    loadData();
    progressValue();
  }

  void wipeData() {
    DBHelper.db.clearTable();
    loadData();
  }

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

  double get _difference => firstItem.weight - lastItem.idealWeight;

  Parameters get lastItem => _parameters.last;

  Parameters get firstItem => _parameters.first;

  bool get isGainWeight => _status == WeightStatus.gainWeight;

  bool get isLoseWeight => _status == WeightStatus.loseWeight;
}
