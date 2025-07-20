import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier {
  Map<String, List<dynamic>> _coreNearestStationsDict = {};
  Map<String, List<dynamic>> get coreNearestStationsDict =>
      _coreNearestStationsDict;
  void updateCoreNearestStationsDict(Map<String, List<dynamic>> data) {
    _coreNearestStationsDict = data;
    notifyListeners();
  }

  //////////------------------------------------------------------
  Map<String, List<dynamic>> _coreTransferStationsDict = {};
  Map<String, List<dynamic>> get coreTransferStationsDict =>
      _coreTransferStationsDict;
  void updateCoreTransferStationsDict(Map<String, List<dynamic>> data) {
    _coreTransferStationsDict = data;
    notifyListeners();
  }
}
