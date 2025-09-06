import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

// -------------------- LINE COLORS --------------------
Color getLineColor(int lineNumber) {
  switch (lineNumber) {
    case 1:
      return const Color.fromARGB(255, 209, 52, 56); // Red
    case 2:
      return const Color.fromARGB(255, 200, 155, 0); // Yellow
    case 3:
      return const Color.fromARGB(255, 0, 122, 204); // Blue main
    case 4:
      return const Color.fromARGB(255, 0, 142, 224); // Blue branch
    case 5:
      return const Color.fromARGB(255, 0, 168, 107); // Green
    case 6:
      return const Color.fromARGB(255, 125, 68, 157); // Violet
    case 7:
      return const Color.fromARGB(255, 219, 112, 147); // Pink
    case 8:
      return const Color.fromARGB(255, 170, 0, 119); // Magenta
    case 9:
      return const Color.fromARGB(255, 130, 130, 130); // Grey
    case 10:
      return const Color.fromARGB(255, 255, 114, 12); // Airport
    case 15:
      return const Color.fromARGB(255, 0, 185, 235); // Rapid Metro
    case 20:
      return const Color.fromARGB(255, 0, 185, 235); // Aqua Line
    default:
      return Colors.grey;
  }
}

// -------------------- MODEL --------------------
class ScheduleInfo {
  final String destination;
  final String lineId;
  final Color lineColor;
  final String frequencyText;
  final int minutesLeft;
  final bool isPeak;

  ScheduleInfo({
    required this.destination,
    required this.lineId,
    required this.lineColor,
    required this.frequencyText,
    required this.minutesLeft,
    required this.isPeak,
  });
}

// -------------------- HELPERS --------------------
int _parseMinutes(String frequency) {
  if (frequency == "-") return 0;
  final match = RegExp(r'\d+').firstMatch(frequency);
  return match != null ? int.tryParse(match.group(0)!) ?? 0 : 0;
}

// -------------------- FETCHING --------------------
Future<List<ScheduleInfo>> getScheduleForStation(
  String stationCode,
  List<Map<String, dynamic>> stationsJson,
  Map<String, dynamic> scheduleJson,
) async {
  final stationData = stationsJson.firstWhere(
    (s) => s['StationCode'] == stationCode,
    orElse: () => throw Exception("Station with code '$stationCode' not found"),
  );

  final lineValue = stationData['Line'];
  if (lineValue == null) {
    throw Exception(
      "Line information is missing for station code: $stationCode",
    );
  }

  // ✅ CHANGE: Handle single ("3") and multiple ("1-3-5") line numbers
  final List<int> lineNumbers =
      lineValue.toString().split('-').map(int.parse).toList();
  final stationName = stationData['StationName'] ?? 'this station';

  final now = DateTime.now();
  final weekday = now.weekday; // 1=Mon, 7=Sun

  String dayKey;
  if (weekday == 7) {
    dayKey = "sunday";
  } else if (weekday == 6) {
    dayKey = "saturday";
  } else {
    dayKey = "weekday";
  }

  bool isNowPeak = false;
  if (scheduleJson['peak_ranges'] != null) {
    final currentMinutes = now.hour * 60 + now.minute;
    for (var range in scheduleJson['peak_ranges']) {
      final start = range['start'].split(':');
      final end = range['end'].split(':');
      final startMinutes = int.parse(start[0]) * 60 + int.parse(start[1]);
      final endMinutes = int.parse(end[0]) * 60 + int.parse(end[1]);
      if (currentMinutes >= startMinutes && currentMinutes <= endMinutes) {
        isNowPeak = true;
        break;
      }
    }
  }

  // ✅ CHANGE: Create a list to hold schedules from all applicable lines
  final List<ScheduleInfo> allSchedules = [];

  // ✅ CHANGE: Loop through each line number and fetch its schedule
  for (final lineNumber in lineNumbers) {
    final peakSchedules = List<Map<String, dynamic>>.from(
      scheduleJson['metro_frequency']['peak_hours'][lineNumber.toString()] ??
          [],
    );
    final offPeakSchedules = List<Map<String, dynamic>>.from(
      scheduleJson['metro_frequency']['off_peak_hours'][lineNumber
              .toString()] ??
          [],
    );

    final selectedSchedules = isNowPeak ? peakSchedules : offPeakSchedules;

    final schedulesForThisLine =
        selectedSchedules.map((s) {
          final frequency = s[dayKey] ?? "-";
          return ScheduleInfo(
            destination: s['section'] ?? "All Sections",
            lineId: "Line $lineNumber",
            lineColor: getLineColor(lineNumber),
            frequencyText: frequency,
            minutesLeft: _parseMinutes(frequency),
            isPeak: isNowPeak,
          );
        }).toList();

    allSchedules.addAll(schedulesForThisLine);
  }

  if (allSchedules.isEmpty) {
    throw Exception("No upcoming trains for $stationName");
  }

  return allSchedules;
}

// -------------------- UI WIDGET --------------------
class ScheduleWidget extends StatefulWidget {
  final String stationCode;
  const ScheduleWidget({super.key, required this.stationCode});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  List<ScheduleInfo> schedules = [];
  String stationName = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final stationsStr = await rootBundle.loadString(
        'assets/Map/stationsjson.json',
      );
      final scheduleStr = await rootBundle.loadString(
        'assets/Map/newRoundedTimeTable.json',
      );
      final stationsJson = List<Map<String, dynamic>>.from(
        jsonDecode(stationsStr),
      );
      final scheduleJson = jsonDecode(scheduleStr);

      final stationDataForName = stationsJson.firstWhere(
        (s) => s['StationCode'] == widget.stationCode,
        orElse: () => <String, dynamic>{},
      );
      stationName = stationDataForName['StationName'] ?? 'the selected station';

      final scheduleList = await getScheduleForStation(
        widget.stationCode,
        stationsJson,
        scheduleJson,
      );

      if (mounted) {
        setState(() {
          schedules = scheduleList;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = e.toString().replaceFirst("Exception: ", "");
          isLoading = false;
        });
      }
    }
  }

  Widget _buildDestinationText(String destination) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    );
    if (destination.contains(" to ")) {
      final parts = destination.split(" to ");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(parts[0], style: style),
          Text("till ${parts[1]}", style: style),
        ],
      );
    } else {
      return Text(destination, style: style);
    }
  }

  Widget _buildScheduleBlock(ScheduleInfo schedule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 33, 33),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDestinationText(schedule.destination),
                    const SizedBox(height: 4.0),
                    Text(
                      schedule.lineId,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: Container(color: schedule.lineColor, width: 5.0),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(color: Color.fromARGB(255, 33, 33, 33)),
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Every",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  // decoration: BoxDecoration(
                  //   color:
                  //       schedule.minutesLeft >= 5
                  //           ? Colors.red.shade50
                  //           : Colors.green.shade50,
                  //   borderRadius: BorderRadius.circular(50),
                  //   border: Border.all(
                  //     color:
                  //         schedule.minutesLeft >= 5
                  //             ? Colors.red.shade200
                  //             : Colors.green.shade200,
                  //     width: 1,
                  //   ),
                  // ),
                  child: Text(
                    schedule.frequencyText,
                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    if (hasError) {
      return SizedBox(
        height: 200.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48.0),
              const SizedBox(height: 16.0),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return SizedBox(
        height: 200.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.train, color: Colors.grey, size: 48.0),
              const SizedBox(height: 16.0),
              Text(
                'No upcoming trains\nfor $stationName',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          schedules.map((schedule) => _buildScheduleBlock(schedule)).toList(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          const Text(
            "SCHEDULE ",
            style: TextStyle(
              color: Color.fromARGB(255, 109, 109, 109),
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          //Lottie.asset('assets/Image/scanning.json', height: 20, width: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator(radius: 20));
    }

    return SingleChildScrollView(
      //padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildScheduleList()],
      ),
    );
  }
}
