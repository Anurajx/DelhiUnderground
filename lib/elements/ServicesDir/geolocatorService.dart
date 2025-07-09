import 'dart:isolate';
//import 'global.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metroapp/elements/ServicesDir/Station_element.dart';

void initilize() async {
  await getCurrentLocation(); // If you need it for permission or service check

  List<List<dynamic>> originalStations = await loadStationsFromCSV();

  // Get user's current location
  Position userPosition = await getCurrentLocation();
  double userLat = userPosition.latitude;
  double userLon = userPosition.longitude;

  // Find closest station
  originalStations.sort((a, b) {
    double distA = Geolocator.distanceBetween(
      userLat,
      userLon,
      double.parse(a[4].toString()),
      double.parse(a[5].toString()),
    );
    double distB = Geolocator.distanceBetween(
      userLat,
      userLon,
      double.parse(b[4].toString()),
      double.parse(b[5].toString()),
    );
    return distA.compareTo(distB); // Ascending sort
  });

  var nearest = originalStations[0];
  var nextNearest = originalStations[1];
  coreNearestStationsDict['UserLocation'] = [userPosition];
  coreNearestStationsDict['Near'] = [nearest];
  coreNearestStationsDict['NearEnough'] = [nextNearest];
  print("coreNearestStationsDict: $coreNearestStationsDict['Near']");
  print(coreNearestStationsDict['NearEnough']);
}

////////////////////////////////////////
///
///
///
///
///
///
///
///
Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print("Location services are disabled.");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print("Permission Denied Forever");
  }

  return await Geolocator.getCurrentPosition();
}

Future<List<List<dynamic>>> loadStationsFromCSV() async {
  final rawData = await rootBundle.loadString('assets/Map/stops.csv');
  final List<List<dynamic>> rows = await Isolate.run(() {
    return CsvToListConverter(
      eol: '\n',
      fieldDelimiter: ',',
      textDelimiter: '"',
      shouldParseNumbers: false,
    ).convert(rawData);
  });
  return rows;
}

Map<String, List<dynamic>> coreNearestStationsDict = {
  //used for transfer screen process, making sure both source and destination are available
  //Dictionary format
  'UserLocation': [],
  'Near': [], //adding some defaults
  'NearEnough': [],
};
