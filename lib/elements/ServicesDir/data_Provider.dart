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
  void updateJustData(Map<String, dynamic> newSearch) {
    // Deep copy of previous 'just' if it exists
    final prev = _coreTransferStationsDict['just'];
    final justBefore =
        prev != null ? prev.map((e) => _deepCopyTransferData(e)).toList() : [];

    // Deep copy the new search to prevent reference issues
    final justNow = [_deepCopyTransferData(newSearch)];

    _coreTransferStationsDict = {'just': justNow, 'justBefore': justBefore};

    notifyListeners();
  }

  Map<String, dynamic> _deepCopyTransferData(Map<String, dynamic> input) {
    final copy = <String, dynamic>{};

    input.forEach((key, value) {
      if (value is List) {
        copy[key] = List.from(value);
      } else if (value is Map) {
        copy[key] = Map<String, dynamic>.from(value);
      } else {
        copy[key] = value;
      }
    });

    return copy;
  }
}
