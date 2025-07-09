import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  Map<String, dynamic> _coreNearestStationsDict = {};
  Map<String, dynamic> get coreNearestStationsDict => _coreNearestStationsDict;
  void updateCoreNearestStationsDict(Map<String, List<dynamic>> data) {
    _coreNearestStationsDict = data;
    notifyListeners();
  }
}
