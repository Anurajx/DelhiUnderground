//FILE FOR SEPRATELY FETCHING STATIONS ,METRO LINES AND MAP STYLES FROM FILE

import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapData {
  //final String mapStyle;
  final List<LatLng> stops;
  final List<Polyline> lines;
  mapData({required this.stops, required this.lines});
}

//FUNCTION FOR FETCHING METRO LINES
Future<List<Polyline>> loadMetroPolylinesFromGTFS() async {
  final rawData = await rootBundle.loadString('assets/Map/shapes.txt');
  final lines = rawData.split('\n');
  final Map<String, List<Map<String, dynamic>>> shapes = {};

  for (String line in lines) {
    final parts = line.trim().split(',');

    // Skip header or malformed lines
    if (parts.length < 5 || parts[0] == 'shape_id') continue;

    final shapeId = parts[0];
    final lat = double.tryParse(parts[1]);
    final lon = double.tryParse(parts[2]);
    final seq = int.tryParse(parts[3]);

    if (lat == null || lon == null || seq == null) continue;

    shapes.putIfAbsent(shapeId, () => []).add({
      'lat': lat,
      'lon': lon,
      'seq': seq,
    });
  }

  List<Polyline> polylines = [];
  int polylineIndex = 1;

  shapes.forEach((shapeId, pointsList) {
    pointsList.sort((a, b) => a['seq'].compareTo(b['seq']));
    final points = pointsList.map((p) => LatLng(p['lat'], p['lon'])).toList();

    polylines.add(
      Polyline(
        polylineId: PolylineId('polyline_$polylineIndex'),
        points: points,
        width: 4,
        color: _randomLineColor(polylineIndex),
      ),
    );

    polylineIndex++;
  });

  return polylines;
}

//RANDOM LINE COLORS
Color _randomLineColor(int index) {
  // Sample color list (can be modified to fixed mapping)
  final colors = [
    Color(0xFFE53935), // Red
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFFDD835), // Yellow
    Color(0xFF8E24AA), // Purple
    Color(0xFFFB8C00), // Orange
  ];
  return colors[index % colors.length];
}

//FUNCTION FOR FETCHING STATIONS
Future<Iterable<LatLng>> loadStations() async {
  final data = await rootBundle.loadString('assets/Map/stops.txt');

  final lines = data.split('\n');
  var finalrows = <LatLng>[];

  for (var line in lines) {
    final parts = line.split(',');
    if (parts.length >= 6) {
      final lat = double.tryParse(parts[4].trim());
      final lng = double.tryParse(parts[5].trim());
      if (lat != null && lng != null) {
        finalrows.add(LatLng(lat, lng));
      }
    } else {
      print("Invalid line: $line");
    }
  }

  print("Parsed stops: ${finalrows.length}");
  return finalrows;
}

Future<mapData> loadMapData() async {
  final stops = (await loadStations()).toList();
  final lines = await loadMetroPolylinesFromGTFS();
  return mapData(stops: stops, lines: lines);
}
