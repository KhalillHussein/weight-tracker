import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status { loading, error, loaded }

/// This class serves as the building blocks of a repository.
///
/// A repository has the purpose to load and parse the data
abstract class BaseRepository<M> with ChangeNotifier {
  List<M> parameters = [];

  /// Status regarding data loading capabilities
  Status _status;

  /// String that saves information about the latest error
  String _errorMessage;

  BaseRepository() {
    startLoading();
    loadData();
  }

  /// Overridable method, used to load the model's data.
  Future<void> loadData();

  /// Overridable method, used to add the model's data.
  Future<void> addData(Map<String, dynamic> map);

  /// Overridable method, used to delete the model's data.
  void deleteData(int id);

  String get errorMessage => _errorMessage;

  bool get isLoading => _status == Status.loading;
  bool get loadingFailed => _status == Status.error;
  bool get isLoaded => _status == Status.loaded;

  /// Signals that information is being downloaded.
  void startLoading() {
    _status = Status.loading;
    notifyListeners();
  }

  /// Signals that information has been downloaded.
  void finishLoading() {
    _status = Status.loaded;
    notifyListeners();
  }

  /// Signals that there has been an error downloading data.
  void receivedError(String error) {
    _status = Status.error;
    _errorMessage = error;
    debugPrint(error);
    notifyListeners();
  }
}
