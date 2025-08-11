import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:csv/csv.dart'; // Keep the CSV package

class MetroTimetableScreen extends StatefulWidget {
  @override
  _MetroTimetableScreenState createState() => _MetroTimetableScreenState();
}

class _MetroTimetableScreenState extends State<MetroTimetableScreen> {
  // --- All the data loading and logic stays the same ---
  Map<String, List<String>> _stationTimes = {};
  String _nextMetroMessage = 'Loading timetable...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimetableDataFromCsv();
  }

  Future<void> _loadTimetableDataFromCsv() async {
    try {
      final rawCsvData = await rootBundle.loadString(
        "assets/01111100_r_rd_mon-fri.csv",
      );
      List<List<dynamic>> csvTable = CsvToListConverter().convert(rawCsvData);

      if (csvTable.isNotEmpty) {
        List<dynamic> headers = csvTable[0];
        Map<String, List<String>> tempStationTimes = {};

        for (int i = 1; i < headers.length; i++) {
          tempStationTimes[headers[i].toString()] = [];
        }
        for (int i = 1; i < csvTable.length; i++) {
          List<dynamic> row = csvTable[i];
          for (int j = 1; j < row.length; j++) {
            String stationName = headers[j].toString();
            String time = row[j].toString();
            if (time.isNotEmpty) {
              tempStationTimes[stationName]?.add(time);
            }
          }
        }

        final timeFormat = DateFormat("h:mma");
        tempStationTimes.forEach((station, times) {
          times.sort(
            (a, b) => timeFormat.parse(a).compareTo(timeFormat.parse(b)),
          );
        });

        setState(() {
          _stationTimes = tempStationTimes;
          _isLoading = false;
          // For testing, let's find the next metro from the first station
          _findNextMetroForTest("Inderlok");
        });
      }
    } catch (e) {
      setState(() {
        _nextMetroMessage = "Error: Could not load timetable from CSV.";
        _isLoading = false;
      });
    }
  }

  // A simplified function for testing a single hardcoded station
  void _findNextMetroForTest(String stationName) {
    final List<String>? schedule = _stationTimes[stationName];
    if (schedule == null || schedule.isEmpty) {
      setState(() {
        _nextMetroMessage = 'No schedule found for $stationName.';
      });
      return;
    }
    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat("h:mma");
    String? nextTrainTime;
    for (final timeStr in schedule) {
      final DateTime trainTime = timeFormat.parse(timeStr);
      final DateTime todayTrainDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        trainTime.hour,
        trainTime.minute,
      );
      if (todayTrainDateTime.isAfter(now)) {
        nextTrainTime = timeStr;
        break;
      }
    }
    setState(() {
      if (nextTrainTime != null) {
        _nextMetroMessage = 'Next from Rithala: $nextTrainTime';
      } else {
        _nextMetroMessage = 'No more metros from Rithala today.';
      }
    });
  }

  //
  // --- THE NEW, ULTRA-SIMPLE BUILD METHOD ---
  //
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          _isLoading
              ? CircularProgressIndicator() // Show a loader while processing
              : Text(
                _nextMetroMessage, // Display the result directly
                //style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
    );
  }
}
