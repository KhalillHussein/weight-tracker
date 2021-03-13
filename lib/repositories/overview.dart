import 'dart:math';

import '../models/index.dart';
import '../services/db_service.dart';
import 'index.dart';

///"Перечисление" в котором указаны статусы: набор веса/похудение
enum WeightStatus { loseWeight, gainWeight }

/// Репозиторий, содержащий информацию о всех измеренных и введенных параметрах.
class OverviewRepository extends BaseRepository<Parameters> {
  //Переменная, содержащая множитель, который позволяет переводить значение
  //веса в другие единицы измерения
  double weightUnit = 1.0;

  //Переменная, содержащая статус, согласно которому можно определить
  //пользователь набирает вес или худеет.
  WeightStatus _status;

  //список объектов, значения которых используются во всем приложении
  //Данный список заполняется при сохранении пользователем новых данных и
  //при загрузке данных из базы данных.
  List<Parameters> _parameters = [];

  //Метод get для получения данных из списка в других классах
  @override
  List<Parameters> get parameters => [..._parameters];

  @override
  Future<void> loadData() async {
    //Пробуем загрузить данные из базы данных
    try {
      //Получение данных из БД
      final loadedData = await DbService.db.getData('parameters');
      //Парсинг данных с последующим заполнением списка
      _parameters = [for (final item in loadedData) Parameters.fromMap(item)];
      //Перебор каждого элемента списка, с последующим переводом весовых
      //параметров в выбранные единицы измерения
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
      finishLoading();
    } catch (e) {
      //получение статуса ошибки в случае ошибки
      receivedError(e.toString());
    }
  }

  //Асинхронный метод, через который реализуется добавление данных в БД
  @override
  Future<void> addData(Map<String, dynamic> map) async {
    startLoading();
    await DbService.db.insert(map, 'parameters');
    loadData();
  }

  //Метод, реализующий удаление данных с указанным id из БД
  @override
  void deleteData(int id) {
    DbService.db.deleteItem(id, 'parameters');
    loadData();
    progressValue();
  }

  //Метод реализующий полное удаление БД
  void wipeData() {
    DbService.db.clearTable('parameters');
    loadData();
  }

  //Метод через который реализуется подсчет значения на шкале веса
  int progressValue() {
    //Задаем значение изначального веса
    final int firstValue = firstItem.weight.round();
    //Задаем значение текущего веса
    final int currentValue = lastItem.weight.round();
    //Задаем позицию на шкале веса - это разница между текущим весом и первоначальным
    final position = (lastItem.weight.round() - firstItem.weight.round()).abs();

    //Если разница < 0, то это означает, что пользователю необходимо набрать вес.
    if (difference.isNegative) {
      _status = WeightStatus.gainWeight;
      //текущее значение веса меньше первоначального - возвращаем 0, т.о.
      //шкала не заполнена, находится на позиции 0.
      if (currentValue < firstValue) {
        return 0;
      }
      //Если разница > 0, то это означает, что пользователю необходимо сбросить вес.
    } else if (difference > 0) {
      _status = WeightStatus.loseWeight;
      //текущее значение веса больше первоначального - возвращаем 0, т.о.
      //шкала не заполнена, находится на позиции 0.
      if (currentValue > firstValue) {
        return 0;
      }
    }
    return min(position,
        (lastItem.idealWeight.round() - firstItem.weight.round()).abs());
  }

  //Методы get данные которых будут использованы в других классах
  double get difference => firstItem.weight - lastItem.idealWeight;

  Parameters get lastItem => _parameters.last;

  Parameters get firstItem => _parameters.first;

  bool get isGainWeight => _status == WeightStatus.gainWeight;

  bool get isLoseWeight => _status == WeightStatus.loseWeight;
}
