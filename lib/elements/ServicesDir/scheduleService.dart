import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class schedulePage extends StatelessWidget {
  const schedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MetroHome();
  }
}

class Trip {
  final Map<String, String> stationTimes;
  Trip(this.stationTimes);

  factory Trip.fromJson(Map<String, dynamic> json) {
    final map = <String, String>{};
    json.forEach((key, value) {
      if (key != 'ID' && value != null) {
        map[key] = value.toString();
      }
    });
    return Trip(map);
  }
}

class MetroHome extends StatefulWidget {
  const MetroHome({super.key});

  @override
  State<MetroHome> createState() => _MetroHomeState();
}

class _MetroHomeState extends State<MetroHome> {
  List<Trip> trips = [];
  List<String> stations = [];
  String? selectedStation;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final raw = await rootBundle.loadString('assets/newTimeTable.json');
    final List list = jsonDecode(raw);
    trips =
        list.map((e) => Trip.fromJson(Map<String, dynamic>.from(e))).toList();

    final stationSet = <String>{};
    for (var trip in trips) {
      stationSet.addAll(trip.stationTimes.keys);
    }
    stations = stationSet.toList()..sort();
    selectedStation = stations.first;

    setState(() {});
  }

  String? getNextTrain(String station) {
    final now = DateTime.now();
    final fmt = DateFormat('h:mma'); // we’ll normalize times before parsing
    final times = <DateTime>[];

    for (var trip in trips) {
      final timeStr = trip.stationTimes[station];
      if (timeStr == null) continue;
      try {
        // Normalize: remove spaces, make AM/PM uppercase
        final normalized = timeStr.trim().toUpperCase().replaceAll(' ', '');
        final parsed = fmt.parse(normalized);
        final dt = DateTime(
          now.year,
          now.month,
          now.day,
          parsed.hour,
          parsed.minute,
        );
        if (dt.isAfter(now)) times.add(dt);
      } catch (_) {
        // ignore any bad time
      }
    }

    if (times.isEmpty) return null;
    times.sort();
    final next = times.first;
    final mins = next.difference(now).inMinutes;
    return '${fmt.format(next)}  (${mins} min)';
  }

  @override
  Widget build(BuildContext context) {
    return trips.isEmpty
        ? const Center(child: CupertinoActivityIndicator())
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedStation,
                items:
                    stations
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (v) => setState(() => selectedStation = v),
              ),
              const SizedBox(height: 20),
              Text(
                selectedStation == null
                    ? 'Select station'
                    : (getNextTrain(selectedStation!) ??
                        'No more trains today'),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
  }
}
