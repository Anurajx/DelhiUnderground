import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:metroapp/elements/ServicesDir/report_error_service.dart';
import 'package:metroapp/main.dart';

// ---------------------- DATABASE SERVICE ----------------------
class MetroDbService {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "metro.db");

    final exists = await databaseExists(path);
    if (!exists) {
      await Directory(dirname(path)).create(recursive: true);

      final ByteData data = await rootBundle.load("assets/metro.db");
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(path, readOnly: true);
    return _db!;
  }

  static Future<Map<String, dynamic>?> fetchStation({
    String? stationCode,
    String? stationName,
  }) async {
    final db = await getDatabase();
    if (stationCode != null && stationCode.trim().isNotEmpty) {
      final rows = await db.query(
        'metro_stations',
        where: 'UPPER(station_code) = UPPER(?)',
        whereArgs: [stationCode.trim()],
        limit: 1,
      );
      if (rows.isNotEmpty) return rows.first;
    }

    // if (stationName != null && stationName.trim().isNotEmpty) {
    //   final rows = await db.query(
    //     'metro_stations',
    //     where: 'UPPER(station_name) = UPPER(?)',
    //     whereArgs: [stationName.trim()],
    //     limit: 1,
    //   );
    //   if (rows.isNotEmpty) return rows.first;
    // }

    return null;
  }

  static Future<List<Map<String, Object?>>> fetchLines(
    List<dynamic> lineReferences,
  ) async {
    final lineCodes = <String>[];
    for (final reference in lineReferences) {
      if (reference is Map && reference['line_code'] != null) {
        lineCodes.add(reference['line_code'].toString());
      }
    }
    if (lineCodes.isEmpty) return [];

    final db = await getDatabase();
    final bindMarkers = List.filled(lineCodes.length, '?').join(', ');
    return db.query(
      'metro_lines',
      where: 'line_code IN ($bindMarkers)',
      whereArgs: lineCodes,
    );
  }
}

// ---------------------- STOP INFO SCREEN ----------------------
class StopInfoScreen extends StatefulWidget {
  final dynamic stationDict;
  const StopInfoScreen({super.key, required this.stationDict});

  @override
  State<StopInfoScreen> createState() => _StopInfoScreenState();
}

class _StopInfoScreenState extends State<StopInfoScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _stationData;
  List<Map<String, Object?>> _lineData = [];
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _loadStation();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  String? _extractStationCode(dynamic dict) {
    if (dict == null) return null;
    if (dict is String) return dict;
    if (dict is Map) {
      if (dict['Source'] is Map) {
        final s = dict['Source'];
        return (s['StationCode'] ?? s['station_code'])?.toString();
      }
      return dict['station_code']?.toString();
    }
    return null;
  }

  String? _extractStationName(dynamic dict) {
    if (dict == null) return null;
    if (dict is String) return dict;
    if (dict is Map) {
      if (dict['Source'] is Map) {
        final s = dict['Source'];
        return s['station_name']?.toString();
      }
    }
    return null;
  }

  Future<void> _loadStation() async {
    try {
      final code = _extractStationCode(widget.stationDict);
      final name = _extractStationName(widget.stationDict);
      final data = await MetroDbService.fetchStation(
        stationCode: code,
        stationName: name,
      );
      final lines = await MetroDbService.fetchLines(
        _tryDecodeList(data?['metro_lines']) ?? [],
      );
      if (mounted) {
        setState(() {
          _stationData = data;
          _lineData = lines;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading station data from metro_stations: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<dynamic>? _tryDecodeList(dynamic value) {
    if (value == null) return null;
    if (value is List) return value;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) return decoded;
      } on FormatException catch (error) {
        debugPrint('Invalid station data JSON: $error');
      }
    }
    return null;
  }

  Color _lineColor(Map<String, Object?> line) {
    final colorCode = line['primary_color_code']?.toString();
    if (colorCode == null) return Colors.grey;
    final hex = colorCode.replaceFirst('#', '');
    final value = int.tryParse(hex, radix: 16);
    return value == null ? Colors.grey : Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              topNavBar(context),
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                            radius: 16,
                          ),
                        )
                        : ListView(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          children:
                              _stationData == null
                                  ? const []
                                  : [
                                    _buildStationLineMarker(),
                                    _buildStationTimesWidget(),
                                    _buildStationStatus(context),
                                    SizedBox(height: 2.h),
                                    SizedBox(height: 40.h),
                                    _buildScheduleWidget(),

                                    SizedBox(height: 40.h),
                                    _buildGatesWidget(),
                                    SizedBox(height: 40.h),
                                    _buildAmenitiesWidget(),
                                    SizedBox(height: 40.h),
                                    reportError(),
                                    SizedBox(height: 40.h),
                                    companyFooter(),
                                  ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Station Line Marker
  Widget _buildStationLineMarker() {
    final name = _stationData?['station_name'] ?? '';
    final hindiName = _stationData?['station_name_hindi'];
    // print('Station Name: $name, Hindi Name: $hindiName');

    return SizedBox(
      height: 230.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            name,
            style: TextStyle(
              height: 1.2,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
            ),
          ),
          if (hindiName != null && hindiName.trim().isNotEmpty) ...[
            SizedBox(height: 5.h),
            Text(
              hindiName,
              style: TextStyle(
                color: const Color.fromARGB(255, 240, 240, 240),
                fontWeight: FontWeight.w300,
                fontSize: 18.sp,
              ),
            ),
          ],
          SizedBox(height: 5.h),
          Row(
            children:
                _lineData.map((line) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 3),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: _lineColor(line),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Center(
                        child: Text(
                          line['id']?.toString() ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const Spacer(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  // 2. Station Times Widget (Opening & Closing times)
  Widget _buildStationTimesWidget() {
    final rawOpen = _stationData?['opening_time']?.toString().trim();
    final rawClose = _stationData?['closing_time']?.toString().trim();
    final openTime =
        rawOpen == null || rawOpen.isEmpty
            ? ''
            : rawOpen.length >= 5
            ? rawOpen.substring(0, 5)
            : rawOpen;
    final closeTime =
        rawClose == null || rawClose.isEmpty
            ? ''
            : rawClose.length >= 5
            ? rawClose.substring(0, 5)
            : rawClose;

    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Text(
            'Opens from $openTime until $closeTime',
            style: const TextStyle(
              color: AppColors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Station Status
  Widget _buildStationStatus(BuildContext context) {
    final linesList = _tryDecodeList(_stationData?['metro_lines']);
    final statuses = linesList?.whereType<Map>().toList() ?? [];
    final openStatus = _isStationOpenNow() ? 'OPEN NOW' : 'CLOSED NOW';
    final disruptionStatuses =
        statuses
            .map((line) => line['status']?.toString().trim())
            .whereType<String>()
            .where((status) => status.isNotEmpty)
            .map(
              (status) =>
                  status.toLowerCase().contains('normal')
                      ? openStatus
                      : status.toUpperCase(),
            )
            .toSet();
    final disruptionText =
        disruptionStatuses.isEmpty
            ? openStatus
            : disruptionStatuses.join(' · ');

    return SizedBox(
      height: 80.h,
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _callStation(context),
            child: Container(
              color: const Color.fromARGB(255, 25, 25, 25),
              width: 90.w,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CALL',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    'station',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 130, 130, 130),
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: GestureDetector(
              onTap: _showStationInfo,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: const Color.fromARGB(255, 25, 25, 25),
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            disruptionText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.green,
                          size: 20,
                        ),
                      ],
                    ),
                    Text(
                      'check details',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 130, 130, 130),
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isStationOpenNow() {
    int? toMinutes(dynamic value) {
      if (value == null) return null;
      final match = RegExp(
        r'^(\d{1,2}):(\d{2})(?::\d{2})?$',
      ).firstMatch(value.toString().trim());
      if (match == null) return null;
      final hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      if (hour > 23 || minute > 59) return null;
      return hour * 60 + minute;
    }

    final opening = toMinutes(_stationData?['opening_time']);
    final closing = toMinutes(_stationData?['closing_time']);
    if (opening == null || closing == null) return false;

    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    if (closing < opening) {
      return currentMinutes >= opening || currentMinutes < closing;
    }
    return currentMinutes >= opening && currentMinutes < closing;
  }

  Future<void> _showStationInfo() async {
    final description =
        _stationData?['station_description']?.toString().trim() ?? '';
    final isInterchange =
        _stationData?['interchange'] == true ||
        _stationData?['interchange']?.toString() == '1';

    final details = <Widget>[
      if (description.isNotEmpty)
        Text(
          description,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            height: 1.6,
          ),
        ),
      if (isInterchange) _stationInfoRow('Interchange', 'Yes'),
    ];

    await showModalBottomSheet<void>(
      context: this.context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: const Color.fromARGB(255, 31, 200, 127),
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Text(
                    _stationData?['station_name']?.toString() ??
                        'Station information',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children:
                        details.isEmpty
                            ? [
                              const Text(
                                'No additional station information is available.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                            ]
                            : details,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text(
                        'Okay',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stationInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            height: 1.6,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Future<void> _callStation(BuildContext context) async {
    final phone = [_stationData?['mobile'], _stationData?['landline']]
        .whereType<Object>()
        .map((value) => value.toString().split(RegExp(r'[,;/]')).first.trim())
        .firstWhere((value) => value.isNotEmpty, orElse: () => '');
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: const Color.fromARGB(255, 31, 200, 127),
          content: Text(
            'Station phone number is unavailable',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ),
      );
      return;
    }

    try {
      final launched = await launchUrl(
        Uri(scheme: 'tel', path: phone),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the phone dialer')),
        );
      }
    } catch (error) {
      debugPrint('Error opening station phone number: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the phone dialer')),
        );
      }
    }
  }

  // 4. Schedule Widget
  Widget _buildScheduleWidget() {
    final platforms = _tryDecodeList(_stationData?['platforms']) ?? [];
    final lineReferences = _tryDecodeList(_stationData?['metro_lines']) ?? [];
    final scheduleBlocks = <Widget>[];
    for (final platform in platforms.whereType()) {
      final platformName = platform['platform_name']?.toString().trim();
      final towards = platform['train_towards'];
      final destination =
          towards is Map ? towards['station_name']?.toString().trim() : null;
      if (platformName == null ||
          platformName.isEmpty ||
          destination == null ||
          destination.isEmpty) {
        continue;
      }
      // final destinationUpper = destination.toUpperCase();
      // final matchingReference =
      //     lineReferences.whereType().where((reference) {
      //       final start = reference['start_station']?.toString().toUpperCase();
      //       final end = reference['end_station']?.toString().toUpperCase();
      //       return start == destinationUpper || end == destinationUpper;
      //     }).firstOrNull;
      // final lineReference =
      //     matchingReference ??
      //     (lineReferences.isNotEmpty ? lineReferences.first : null);
      // final lineCode =
      //     lineReference is Map ? lineReference['line_code']?.toString() : null;
      // final line =
      //     _lineData.where((row) => row['line_code'] == lineCode).firstOrNull;
      scheduleBlocks.add(
        _buildScheduleBlock(
          destination: destination,
          platformName: platformName,
          // lineName:
          //     line?['name']?.toString() ??
          //     (lineReference is Map
          //         ? lineReference['name']?.toString() ?? ''
          //         : ''),
          // lineColor: line == null ? Colors.grey : _lineColor(line),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: const Text(
            "SCHEDULE",
            style: TextStyle(
              color: Color.fromARGB(255, 109, 109, 109),
              fontSize: 16.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...scheduleBlocks,
      ],
    );
  }

  Widget _buildScheduleBlock({
    required String destination,
    required String platformName,
    // required String lineName,
    // required Color lineColor,
  }) {
    const cardBg = Color.fromARGB(255, 25, 25, 25);
    const lightText = Color.fromARGB(255, 207, 207, 207);
    // const mutedText = Color.fromARGB(255, 182, 182, 182);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2.0),
      color: cardBg,
      // padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Line color accent block
              // Container(width: 6.0, height: 27.0, color: lineColor),
              // Platform tag on black background
              Container(
                color: const Color.fromARGB(255, 243, 243, 243),
                padding: const EdgeInsets.symmetric(
                  horizontal: 7.0,
                  vertical: 5.0,
                ),
                child: Text(
                  platformName,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          // Top Direction Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  "towards ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 109, 109, 109),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Expanded(
                  child: Text(
                    destination.toLowerCase(),
                    style: const TextStyle(
                      color: lightText,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 8.0),
          // Bottom Flush Tag Strip
        ],
      ),
    );
  }

  // 5. Gates Widget
  Widget _buildGatesWidget() {
    final gatesList = _tryDecodeList(_stationData?['gates']);
    final List<Widget> gateWidgets = [];

    if (gatesList != null && gatesList.isNotEmpty) {
      for (final g in gatesList) {
        if (g is! Map) continue;
        final gateCode = g['gate_code']?.toString().trim();
        final location = g['location']?.toString().trim();
        if (gateCode == null ||
            gateCode.isEmpty ||
            location == null ||
            location.isEmpty) {
          continue;
        }
        gateWidgets.add(exitBlock(gateCode, location));
      }
    }
    if (gateWidgets.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "EXIT",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        ...gateWidgets,
      ],
    );
  }

  Widget exitBlock(String gateCode, String location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            SizedBox(
              height: 60.h,
              width: double.infinity,
              child: Row(
                children: [
                  Container(width: 80.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      color: const Color.fromARGB(255, 25, 25, 25),
                      child: Row(
                        children: [
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              location.toLowerCase(),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60.h,
              width: 80.w,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 25, 25, 25),
                ),
              ),
              child: Center(
                child: Text(
                  gateCode,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  // 6. Amenities Widget
  Widget _buildAmenitiesWidget() {
    final parkingsList = _tryDecodeList(_stationData?['parkings']);
    int carSlots = 0;
    int bikeSlots = 0;
    int cycleSlots = 0;

    if (parkingsList != null && parkingsList.isNotEmpty) {
      for (final p in parkingsList) {
        if (p is Map) {
          carSlots += (p['capacity_car'] as num?)?.toInt() ?? 0;
          bikeSlots += (p['capacity_motorcycle'] as num?)?.toInt() ?? 0;
          cycleSlots += (p['capacity_cycle'] as num?)?.toInt() ?? 0;
        }
      }
    }

    final carStatus = carSlots > 0 ? 'available' : 'unavailable';
    final carSlotsText = '$carSlots slots';
    final bikeStatus = bikeSlots > 0 ? 'available' : 'unavailable';
    final bikeSlotsText = '$bikeSlots slots';
    final cycleStatus = cycleSlots > 0 ? 'available' : 'unavailable';
    final cycleSlotsText = '$cycleSlots slots';

    final stationType = _stationData?['station_type']?.toString() ?? '';
    final elevated =
        stationType.toLowerCase().contains('elevated') ? 'Yes' : 'No';
    final facilitiesList = _tryDecodeList(_stationData?['stations_facilities']);
    final washroom =
        facilitiesList?.any(
                  (facility) =>
                      facility is Map &&
                      facility['kind']?.toString().toLowerCase().contains(
                            'toilet',
                          ) ==
                          true,
                ) ==
                true
            ? 'available'
            : 'unavailable';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "INFORMATION",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        _ammenitiesBlock(
          carStatus: carStatus,
          carSlotsText: carSlotsText,
          bikeStatus: bikeStatus,
          bikeSlotsText: bikeSlotsText,
          cycleStatus: cycleStatus,
          cycleSlotsText: cycleSlotsText,
          elevated: elevated,
          washroom: washroom,
        ),
      ],
    );
  }

  Widget _ammenitiesBlock({
    required String carStatus,
    required String carSlotsText,
    required String bikeStatus,
    required String bikeSlotsText,
    required String cycleStatus,
    required String cycleSlotsText,
    required String elevated,
    required String washroom,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "car parking",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 182, 182, 182),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              color: const Color.fromARGB(255, 207, 207, 207),
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  carStatus,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      14,
                                      14,
                                      14,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  carSlotsText,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      207,
                                      207,
                                      207,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                "assets/Image/carinf.jpeg",
                height: 80.h,
                width: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),

        // Bike parking
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "bike parking",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 182, 182, 182),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              color: const Color.fromARGB(255, 207, 207, 207),
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  bikeStatus,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      14,
                                      14,
                                      14,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  bikeSlotsText,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      207,
                                      207,
                                      207,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                "assets/Image/bikeinf.jpeg",
                height: 80.h,
                width: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),

        // Cycle parking
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "cycle parking",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 182, 182, 182),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              color: const Color.fromARGB(255, 207, 207, 207),
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  cycleStatus,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      14,
                                      14,
                                      14,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              color: Colors.black,
                              padding: const EdgeInsets.all(5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  cycleSlotsText,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      207,
                                      207,
                                      207,
                                    ),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                "assets/Image/cycleinf.jpeg",
                height: 80.h,
                width: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 50.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Text(
                'elevated',
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '>',
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                elevated,
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 50.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Text(
                "washroom",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                ">",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                washroom,
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------- TOP NAV BAR ----------------------
Widget topNavBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              const Icon(
                CupertinoIcons.back,
                color: Color.fromARGB(255, 47, 130, 255),
              ),
              Text(
                "Done",
                style: TextStyle(
                  color: const Color.fromARGB(255, 47, 130, 255),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ---------------------- REPORT ERROR ----------------------
Widget reportError() {
  return Row(
    children: [
      Container(
        height: 50.h,
        width: 170.w,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            try {
              sendToGoogleForm();
            } catch (e) {
              debugPrint("Error sending form: $e");
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "report error",
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 187, 187),
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// ---------------------- COMPANY FOOTER ----------------------
Widget companyFooter() {
  return SizedBox(
    width: double.infinity,
    height: 50.h,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "PLATFORM",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.h,
            color: const Color.fromARGB(255, 90, 90, 90),
            fontWeight: FontWeight.w800,
            fontSize: 14.sp,
          ),
        ),
      ],
    ),
  );
}
