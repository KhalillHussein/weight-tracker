import 'package:flutter/foundation.dart';

///"Перечисление" в котором указаны статусы, используемые при загрузке из БД.
enum Status { loading, error, loaded }

/// Данный класс реализует базовые блоки построения репозитория.
///
/// Репозиторий создан с целью загрузки, и преобразования данных.
abstract class BaseRepository<M> with ChangeNotifier {
  ///Список параметров указанного типа. Он будет переопределен в классе-наследнике
  List<M> parameters = [];

  /// Переменная, которая хранит текущий статус загрузки данных из БД.
  Status _status;

  /// Переменная которая хранит информацию о последней ошибке.
  String _errorMessage;

  BaseRepository() {
    startLoading();
    loadData();
  }

  /// Переопределяемый метод, использующийся для загрузки данных модели.
  Future<void> loadData();

  /// Переопределяемый метод, использующийся для добавления данных модели.
  Future<void> addData(Map<String, dynamic> map);

  /// Переопределяемый метод, использующийся для удаления данных модели.
  void deleteData(int id);

  String get errorMessage => _errorMessage;

  bool get isLoading => _status == Status.loading;
  bool get loadingFailed => _status == Status.error;
  bool get isLoaded => _status == Status.loaded;

  /// Метод, оповещающий, начало загрузки данных из БД.
  void startLoading() {
    _status = Status.loading;
    notifyListeners();
  }

  /// Метод, оповещающий, о том, что данные успешно загружены из БД.
  void finishLoading() {
    _status = Status.loaded;
    notifyListeners();
  }

  /// Метод, оповещающий, что при загрузке данных произошла ошибка.
  void receivedError(String error) {
    _status = Status.error;
    _errorMessage = error;
    debugPrint(error);
    notifyListeners();
  }
}
