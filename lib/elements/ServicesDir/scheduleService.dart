import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class RouteService {
  Database? _db;

  /// Initialize DB from assets if not already copied
  Future<void> initDb() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, "routes.db");

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load("assets/routes.db");
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(path);
  }

  /// Compatibility layer: resolve stationCode → DB station_name
  Future<String> _resolveStationName(String stationCode) async {
    try {
      final jsonData = await rootBundle.loadString(
        'assets/Map/GTFS_StopsForDataRefrenceForDataMismatch.json',
      );
      final List<dynamic> stops = jsonDecode(jsonData);
      for (var stop in stops) {
        if (stop['stationCode']?.toString().toLowerCase() ==
            stationCode.toLowerCase()) {
          return stop['stop_name']; // return DB-compatible name
        }
      }
    } catch (e) {
      debugPrint("Error resolving station code: $e");
    }
    return stationCode; // fallback
  }

  /// Fetch route info from DB given user dict
  Future<Map<String, dynamic>?> getRouteFromDict(
    Map<String, dynamic> userDict,
  ) async {
    if (_db == null) {
      await initDb();
    }

    final sourceCode = userDict['Source']?['StationCode'] ?? '';
    final destCode = userDict['Destination']?['StationCode'] ?? '';

    if (sourceCode.isEmpty || destCode.isEmpty) {
      debugPrint("Invalid user dict, missing station codes.");
      return null;
    }

    // Resolve codes → DB names
    final sourceName = await _resolveStationName(sourceCode);
    final destName = await _resolveStationName(destCode);

    debugPrint("Resolved: $sourceCode → $sourceName, $destCode → $destName");

    // Query database
    final result = await _db!.query(
      "routes",
      where: "start_station_name = ? AND end_station_name = ?",
      whereArgs: [sourceName, destName],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final row = result.first;
      if (row['route_data'] != null) {
        row['route_data'] = jsonDecode(row['route_data'] as String);
      }

      // Store inside variable
      final routeInfo = {
        'start': row['start_station_name'],
        'end': row['end_station_name'],
        'time': row['total_time_minutes'],
        'interchanges': row['interchange_count'],
        'price': row['price'],
        'route_data': row['route_data'],
      };

      return routeInfo;
    }

    return null;
  }
}
