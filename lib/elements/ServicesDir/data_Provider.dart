import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  Map<String, List<dynamic>> _coreNearestStationsDict = {};
  Map<String, List<dynamic>> get coreNearestStationsDict =>
      _coreNearestStationsDict;
  void updateCoreNearestStationsDict(Map<String, List<dynamic>> data) {
    _coreNearestStationsDict = data;
    notifyListeners();
  }
}

//WELL CLEAN UP THIS MESS TOO
