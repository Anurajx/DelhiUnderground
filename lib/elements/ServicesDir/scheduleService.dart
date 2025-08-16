import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchedulePage extends StatelessWidget {
  final String stationName;

  const SchedulePage({super.key, required this.stationName});

  @override
  Widget build(BuildContext context) {
    return MetroScheduleWidget(stationName: stationName);
  }
}

class Trip {
  final String lineId;
  final String destination;
  final Map<String, String> stationTimes;
  final String tripId;

  Trip({
    required this.lineId,
    required this.destination,
    required this.stationTimes,
    required this.tripId,
  });

  factory Trip.fromCsv(
    List<String> headers,
    List<String> row,
    String fileName,
  ) {
    try {
      final stationTimes = <String, String>{};
      String tripId = '';
      String destination = 'Unknown';

      // Parse the CSV row
      for (int i = 0; i < headers.length && i < row.length; i++) {
        final header = headers[i].trim();
        final value = row[i].trim();

        if (header == 'ID') {
          tripId = value;
        } else if (header.isNotEmpty && value.isNotEmpty) {
          stationTimes[header] = value;
        }
      }

      // The last station in the route is typically the destination
      if (headers.length > 1) {
        destination = headers.last.trim();
      }

      return Trip(
        lineId: _extractLineFromFileName(fileName),
        destination: destination,
        stationTimes: stationTimes,
        tripId: tripId,
      );
    } catch (e) {
      return Trip(
        lineId: 'Unknown Line',
        destination: 'Unknown',
        stationTimes: {},
        tripId: '',
      );
    }
  }

  static String _extractLineFromFileName(String fileName) {
    try {
      final lower = fileName.toLowerCase();
      if (lower.contains('_r_rd_') || lower.contains('_r_rs_'))
        return 'Red Line';
      if (lower.contains('_y_hs_') ||
          lower.contains('_y_qv_') ||
          lower.contains('_y_hq_'))
        return 'Yellow Line';
      if (lower.contains('_b_dn_') || lower.contains('_b_dv_'))
        return 'Blue Line';
      if (lower.contains('_g_kb_') || lower.contains('_g_ib_'))
        return 'Green Line';
      if (lower.contains('_g_dd_')) return 'Grey Line';
      if (lower.contains('_v_kb_') || lower.contains('_v_kr_'))
        return 'Violet Line';
      if (lower.contains('_p_ms_')) return 'Pink Line';
      if (lower.contains('_m_jb_')) return 'Magenta Line';
      if (lower.contains('_o_dn_')) return 'Orange Line';
      if (lower.contains('_r_sp_')) return 'Rapid Metro';
      if (lower.contains('_a_nn_') || lower.contains('_a_nd_'))
        return 'Aqua Line';
      return 'Metro Line';
    } catch (e) {
      return 'Metro Line';
    }
  } //TODO: Line and name color with staiotn on aqua line and blue line
}

class ScheduleInfo {
  final String lineId;
  final String destination;
  final String nextTime;
  final int minutesLeft;
  final Color lineColor;

  ScheduleInfo({
    required this.lineId,
    required this.destination,
    required this.nextTime,
    required this.minutesLeft,
    required this.lineColor,
  });
}

class MetroScheduleWidget extends StatefulWidget {
  final String stationName;

  const MetroScheduleWidget({super.key, required this.stationName});

  @override
  State<MetroScheduleWidget> createState() => _MetroScheduleWidgetState();
}

class _MetroScheduleWidgetState extends State<MetroScheduleWidget> {
  List<Trip> allTrips = [];
  List<ScheduleInfo> schedules = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  Timer? _timer;

  static const Map<String, Color> lineColors = {
    'Red Line': Color.fromARGB(255, 209, 52, 56),
    'Yellow Line': Color.fromARGB(255, 200, 155, 0),
    'Blue Line': Color.fromARGB(255, 0, 122, 204),
    'Blue Line Branch': Color.fromARGB(255, 0, 142, 224),
    'Green Line': Color.fromARGB(255, 0, 168, 107),
    'Violet Line': Color.fromARGB(255, 125, 68, 157),
    'Pink Line': Color.fromARGB(255, 219, 112, 147),
    'Magenta Line': Color.fromARGB(255, 170, 0, 119),
    'Grey Line': Color.fromARGB(255, 130, 130, 130),
    'Airport Express': Color.fromARGB(255, 255, 114, 12),
    'Rapid Metro': Color.fromARGB(255, 0, 185, 235),
    'Aqua Line': Color.fromARGB(255, 0, 185, 235),
    'Orange Line': Color.fromARGB(255, 255, 100, 17),
  };

  // List of CSV files to load
  static const List<String> csvFiles = [
    '01111100_r_rd_mon-fri',
    '11111100_r_rs_mon-fri',
    '21111100_y_hs_mon-fri',
    '31111100_y_qv_mon-fri',
    '41111100_y_hq_mon-fri',
    '51111100_b_dn_mon-fri',
    '61111100_b_dv_mon-fri',
    '71111100_g_kb_mon-fri',
    '81111100_g_ib_mon-fri',
    '91111100_v_kb_mon-fri',
    '101111100_v_kr_mon-fri',
    '111111100_p_ms_mon-fri',
    '121111100_m_jb_mon-fri',
    '131111100_g_dd_mon-fri',
    '141111100_o_dn_mon-fri',
    '151111100_r_sp_mon-fri',
    '161111100_a_nn_mon-fri',
    '171111100_a_nd_mon-fri',
    '181111100_r_rd_r_mon-fri',
    '190000010_r_rs_r_sat',
    '201111100_y_hs_r_mon-fri',
    '211111100_y_qv_r_mon-fri',
    '221111100_y_hq_r_mon-fri',
    '231111100_b_dn_r_mon-fri',
    '241111100_b_dv_r_mon-fri',
    '251111100_g_kb_r_mon-fri',
    '261111100_g_ib_r_mon-fri',
    '271111100_v_kb_r_mon-fri',
    '281111100_v_kr_r_mon-fri',
    '291111100_p_ms_r_mon-fri',
    '301111100_m_jb_r_mon-fri',
    '311111100_g_dd_r_mon-fri',
    '321111100_o_dn_r_mon-fri',
    '331111100_r_sp_r_mon-fri',
    '341111100_a_nn_r_mon-fri',
    '351111100_a_nd_r_mon-fri',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScheduleData();
    });

    // Start timer for dynamic updates every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        _generateSchedulesForStation();
        setState(() {});
      }
    });
  }

  Future<void> _loadScheduleData() async {
    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = '';
      });

      await _loadAllCsvFiles();
      if (mounted) {
        _generateSchedulesForStation();
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to load schedule data: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _loadAllCsvFiles() async {
    allTrips.clear();
    int loadedFiles = 0;

    for (String fileName in csvFiles) {
      try {
        final csvData = await rootBundle.loadString(
          'assets/TimeTable/$fileName.csv',
        );
        final trips = _parseCsvData(csvData, fileName);
        allTrips.addAll(trips);
        loadedFiles++;
        print('Loaded $fileName: ${trips.length} trips');
      } catch (e) {
        print('Failed to load $fileName: $e');
        // Continue with other files
      }
    }

    print('Loaded $loadedFiles files with ${allTrips.length} total trips');
    print('Looking for station: ${widget.stationName}');
  }

  List<Trip> _parseCsvData(String csvData, String fileName) {
    try {
      final lines = csvData.split('\n');
      if (lines.isEmpty) return [];

      // Parse header
      final headers = lines[0].split(',').map((h) => h.trim()).toList();
      final trips = <Trip>[];

      // Parse data rows
      for (int i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final row = line.split(',').map((cell) => cell.trim()).toList();
        if (row.length >= headers.length) {
          final trip = Trip.fromCsv(headers, row, fileName);
          if (trip.stationTimes.isNotEmpty) {
            trips.add(trip);
          }
        }
      }

      return trips;
    } catch (e) {
      print('Error parsing CSV $fileName: $e');
      return [];
    }
  }

  void _generateSchedulesForStation() {
    if (!mounted) return;

    try {
      final now = DateTime.now();
      final tempSchedules = <ScheduleInfo>[];

      print('Generating schedules for: ${widget.stationName}');

      for (var trip in allTrips) {
        try {
          // Check if this trip serves the requested station
          String? timeStr = _findStationTime(trip, widget.stationName);

          if (timeStr == null || timeStr.isEmpty) continue;

          final scheduleInfo = _parseTimeAndCreateSchedule(timeStr, trip, now);
          if (scheduleInfo != null) {
            tempSchedules.add(scheduleInfo);
          }
        } catch (e) {
          print('Error processing trip: $e');
          continue;
        }
      }

      print('Found ${tempSchedules.length} potential schedules');

      // Sort by time and group by destination
      tempSchedules.sort((a, b) => a.minutesLeft.compareTo(b.minutesLeft));

      // Group by line and destination, take top schedules from each
      final Map<String, List<ScheduleInfo>> grouped = {};
      for (var schedule in tempSchedules) {
        final key = '${schedule.lineId}_${schedule.destination}';
        grouped.putIfAbsent(key, () => []).add(schedule);
      }

      schedules.clear();
      grouped.forEach((key, scheduleList) {
        if (scheduleList.isNotEmpty) {
          schedules.add(
            scheduleList.first,
          ); // Take only the next one per destination
        }
      });

      schedules.sort((a, b) => a.minutesLeft.compareTo(b.minutesLeft));

      // Filter out trains that have already passed (0 or negative minutes)
      schedules =
          schedules.where((schedule) => schedule.minutesLeft > 0).toList();

      schedules = schedules.take(6).toList(); // Show max 6 upcoming trains

      print('Final schedules count: ${schedules.length}');
    } catch (e) {
      print('Error generating schedules: $e');
      schedules.clear();
    }
  }

  String? _findStationTime(Trip trip, String stationName) {
    // Try exact match first
    String? timeStr = trip.stationTimes[stationName];
    if (timeStr != null) return timeStr;

    // Try case-insensitive match
    final lowerStationName = stationName.toLowerCase();
    for (var entry in trip.stationTimes.entries) {
      if (entry.key.toLowerCase() == lowerStationName) {
        return entry.value;
      }
    }

    // Try partial match (contains)
    for (var entry in trip.stationTimes.entries) {
      final stationKey = entry.key.toLowerCase();
      if (stationKey.contains(lowerStationName) ||
          lowerStationName.contains(stationKey)) {
        return entry.value;
      }
    }

    return null;
  }

  ScheduleInfo? _parseTimeAndCreateSchedule(
    String timeStr,
    Trip trip,
    DateTime now,
  ) {
    try {
      final cleanTime = timeStr.trim().toLowerCase();
      if (cleanTime.isEmpty) return null;

      DateTime? parsed;

      // Parse time in format "6:00am" or "6:00 am"
      try {
        String normalizedTime = cleanTime.replaceAll(' ', '');

        if (normalizedTime.endsWith('am') || normalizedTime.endsWith('pm')) {
          // Remove am/pm and parse
          final isAM = normalizedTime.endsWith('am');
          final timeOnly = normalizedTime.substring(
            0,
            normalizedTime.length - 2,
          );

          final parts = timeOnly.split(':');
          if (parts.length == 2) {
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);

            // Convert to 24-hour format
            if (!isAM && hour != 12) {
              hour += 12;
            } else if (isAM && hour == 12) {
              hour = 0;
            }

            parsed = DateTime(now.year, now.month, now.day, hour, minute);
          }
        }
      } catch (e) {
        print('Error parsing time "$timeStr": $e');
        return null;
      }

      if (parsed == null) return null;

      DateTime targetTime = parsed;

      // If the time has passed today, consider it for tomorrow
      if (parsed.isBefore(now)) {
        targetTime = parsed.add(const Duration(days: 1));
      }

      final mins = targetTime.difference(now).inMinutes;

      // Only show trains that haven't passed and are within next 24 hours
      if (mins <= 0 || mins > 1440) return null;

      final displayFormat = DateFormat('h:mm a');

      return ScheduleInfo(
        lineId: trip.lineId,
        destination: trip.destination,
        nextTime: displayFormat.format(targetTime),
        minutesLeft: mins,
        lineColor: lineColors[trip.lineId] ?? Colors.grey,
      );
    } catch (e) {
      print('Error creating schedule info: $e');
      return null;
    }
  }

  Widget _buildScheduleBlock(ScheduleInfo schedule, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        //color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            //offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 33, 33),
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(8),
                  //   topRight: Radius.circular(8),
                  // ),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      schedule.destination,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      schedule.lineId,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  color: schedule.lineColor,
                  height: 10.h,
                  width: 10.w,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              //color: Colors.black,
              border: BoxBorder.all(color: Color.fromARGB(255, 33, 33, 33)),
            ),
            padding: EdgeInsets.all(15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.nextTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        schedule.minutesLeft >= 5
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color:
                          schedule.minutesLeft >= 5
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "${schedule.minutesLeft} min",
                    style: TextStyle(
                      color:
                          schedule.minutesLeft >= 5
                              ? Colors.red.shade700
                              : Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
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
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _loadScheduleData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.train, color: Colors.grey, size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                'No upcoming trains\nfor ${widget.stationName}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'Total trips loaded: ${allTrips.length}',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          schedules
              .map(
                (schedule) =>
                    _buildScheduleBlock(schedule, schedules.indexOf(schedule)),
              )
              .toList(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Text(
        "SCHEDULE",
        style: TextStyle(
          color: const Color.fromARGB(255, 109, 109, 109),
          fontSize: 16.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator(radius: 20));
    }

    return SingleChildScrollView(
      //padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildScheduleList()],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
