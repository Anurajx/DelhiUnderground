import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:metroapp/elements/ServicesDir/data_Provider.dart';

/// Call this from a widget’s `initState` using
/// WidgetsBinding.instance.addPostFrameCallback((_) => initialize(context));
Future<void> initialize(BuildContext context) async {
  try {
    // 1️⃣ Get user location once
    final Position userPosition = await getCurrentLocation();
    final double userLat = userPosition.latitude;
    final double userLon = userPosition.longitude;

    // 2️⃣ Load station CSV
    List<List<dynamic>> originalStations = await loadStationsFromCSV();

    // (Optional) skip CSV header row
    if (originalStations.isNotEmpty &&
        originalStations.first[0].toString().toLowerCase().contains(
          'station',
        )) {
      originalStations = originalStations.skip(1).toList();
    }

    if (originalStations.length < 2) {
      print('⚠️ CSV has less than 2 stations; aborting update');
      return;
    }

    // 3️⃣ Sort by distance
    originalStations.sort((a, b) {
      final distA = Geolocator.distanceBetween(
        userLat,
        userLon,
        double.parse(a[4].toString()),
        double.parse(a[5].toString()),
      );
      final distB = Geolocator.distanceBetween(
        userLat,
        userLon,
        double.parse(b[4].toString()),
        double.parse(b[5].toString()),
      );
      return distA.compareTo(distB);
    });

    final nearest = originalStations[0];
    final nextNearest = originalStations[1];

    // 4️⃣ Push into Provider
    context.read<DataProvider>().updateCoreNearestStationsDict({
      'UserLocation': [userPosition],
      'Near': [nearest],
      'NearEnough': [nextNearest],
    });

    print('🚀 Provider updated with nearest stations');
  } catch (e, st) {
    print('⚠️ initialize() failed: $e\n$st');
  }
}

/// ----- helpers -----------------------------------------------------------

Future<Position> getCurrentLocation() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    throw Exception('Location services disabled.');
    //throw Exception('Location services disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Location permission denied.');
  }

  return Geolocator.getCurrentPosition();
}

Future<List<List<dynamic>>> loadStationsFromCSV() async {
  final rawData = await rootBundle.loadString('assets/Map/stops.csv');
  return Isolate.run(
    () => CsvToListConverter(
      eol: '\n',
      fieldDelimiter: ',',
      textDelimiter: '"',
      shouldParseNumbers: false,
    ).convert(rawData),
  );
}
