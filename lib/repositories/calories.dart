import '../models/index.dart';
import '../services/db_service.dart';
import 'index.dart';

/// Репозиторий, содержащий информацию об указанных продуктах и калориях.
class CaloriesRepository extends BaseRepository<Calories> {
  //список объектов, значения которых используются во всем приложении
  //Данный список заполняется при сохранении пользователем новых данных и
  //при загрузке данных из базы данных.
  List<Calories> _parameters = [];

  //Метод get для получения данных из списка в других классах
  @override
  List<Calories> get parameters => [..._parameters];

  @override
  Future<void> loadData() async {
    //Пробуем загрузить данные из базы данных
    try {
      //Получение данных из БД
      final loadedData = await DbService.db.getData('calories');
      //Парсинг данных с последующим заполнением списка
      _parameters = [for (final item in loadedData) Calories.fromMap(item)];
      finishLoading();
    } catch (e) {
      //получение статуса ошибки в случае ошибки
      receivedError(e.toString());
    }
  }

  ///Асинхронный метод, через который реализуется добавление данных в БД.
  @override
  Future<void> addData(Map<String, dynamic> map) async {
    startLoading();
    await DbService.db.insert(map, 'calories');
    loadData();
  }

  ///Метод, реализующий удаление данных с указанным id из БД.
  @override
  void deleteData(int id) {
    DbService.db.deleteItem(id, 'calories');
    loadData();
  }

  ///метод для получения числа суммарного кол-ва калорий за сегодня.
  double summary() {
    double sum = 0.0;
    for (final item in _parameters) {
      if (isToday(item.date)) {
        sum += item.calories;
      }
    }
    return sum;
  }

  ///Метод для проверки даты, возвращает true если дата == сегодня, иначе false.
  bool isToday(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    return diff == 0 && now.day == date.day;
  }
}
