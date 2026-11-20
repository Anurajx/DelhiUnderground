import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:metroapp/elements/ServicesDir/data_provider.dart';
import 'package:metroapp/elements/StationDir/stop_info.dart';

/// Call this from a widget’s `initState` using
/// WidgetsBinding.instance.addPostFrameCallback((_) => initialize(context));
Future<void> initialize(BuildContext context) async {
  //THIS IS STILL THE FUNCTION THAT WAS MADE FOR LIST AND HAS NOT BEEN UPDATED FOR MAP FOR NOW
  try {
    // 1️⃣ Get user location once
    final Position userPosition = await getCurrentLocation();
    final double userLat = userPosition.latitude;
    final double userLon = userPosition.longitude;

    // 2️⃣ Load station rows with coordinates from metro.db.
    final db = await MetroDbService.getDatabase();
    final stations =
        (await db.query('metro_stations'))
            .where(
              (station) =>
                  station['latitude'] is num && station['longitude'] is num,
            )
            .toList();

    if (stations.length < 2) {
      debugPrint('Fewer than two stations have coordinates in metro.db.');
      return;
    }

    // 3️⃣ Sort by distance
    stations.sort((a, b) {
      final distA = Geolocator.distanceBetween(
        userLat,
        userLon,
        (a['latitude'] as num).toDouble(),
        (a['longitude'] as num).toDouble(),
      );
      final distB = Geolocator.distanceBetween(
        userLat,
        userLon,
        (b['latitude'] as num).toDouble(),
        (b['longitude'] as num).toDouble(),
      );
      return distA.compareTo(distB);
    });

    final nearest = stations[0];
    final nextNearest = stations[1];

    // 4️⃣ Push into Provider
    if (context.mounted) {
      context.read<DataProvider>().updateCoreNearestStationsDict({
        'UserLocation': [userPosition],
        'Near': [nearest],
        'NearEnough': [nextNearest],
      });
    }

    debugPrint('Provider updated with nearest stations from metro.db.');
  } catch (e, st) {
    debugPrint('initialize() failed: $e\n$st');
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
