import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// -------------------- MODEL --------------------
class LineStatusInfo {
  final int lineId;
  final String lineName;
  final Color color;
  final String name;
  final String lineCode;
  final String lineColorFamily;
  final String secondaryColorCode;
  final int stationCount;
  final String startStation;
  final String endStation;
  final int junctionCount;
  final String status;
  final bool hasDisruption;
  final String? disruptionMessage;

  const LineStatusInfo({
    required this.lineId,
    required this.lineName,
    required this.color,
    this.name = '',
    this.lineCode = '',
    this.lineColorFamily = '',
    this.secondaryColorCode = '',
    this.stationCount = 0,
    this.startStation = '',
    this.endStation = '',
    this.junctionCount = 0,
    this.status = 'Normal Service',
    this.hasDisruption = false,
    this.disruptionMessage,
  });

  factory LineStatusInfo.fromDatabase(Map<String, dynamic> row) {
    final lineId = row['id'] as int;
    final lineName = row['line_color_verbose']?.toString() ?? 'Line $lineId';
    final colorCode = row['primary_color_code']?.toString() ?? '#808080';
    final status = row['status']?.toString() ?? 'Normal Service';
    final hasDisruption =
        status.toLowerCase() != 'normal service' && status.trim().isNotEmpty;

    return LineStatusInfo(
      lineId: lineId,
      lineName: lineName,
      color: Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000),
      name: row['name']?.toString() ?? '',
      lineCode: row['line_code']?.toString() ?? '',
      lineColorFamily: row['line_color_family']?.toString() ?? '',
      secondaryColorCode: row['secondary_color_code']?.toString() ?? '',
      stationCount:
          row['station_count'] is int ? row['station_count'] as int : 0,
      startStation: _stationName(row['start_station']),
      endStation: _stationName(row['end_station']),
      junctionCount:
          row['junction_count'] is int ? row['junction_count'] as int : 0,
      status: status,
      hasDisruption: hasDisruption,
      disruptionMessage: hasDisruption ? status : null,
    );
  }

  static String _stationName(dynamic value) {
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map && decoded['station_name'] != null) {
          return decoded['station_name'].toString();
        }
      } catch (_) {}
    } else if (value is Map && value['station_name'] != null) {
      return value['station_name'].toString();
    }
    return '';
  }
}

// -------------------- FULL SCREEN WIDGET --------------------
class LineStatusScreen extends StatefulWidget {
  final List<LineStatusInfo>? statuses;

  const LineStatusScreen({super.key, this.statuses});

  @override
  State<LineStatusScreen> createState() => _LineStatusScreenState();
}

class _LineStatusScreenState extends State<LineStatusScreen> {
  static const Color _screenBg = Colors.black;

  List<LineStatusInfo> _lineStatuses = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    if (widget.statuses != null) {
      _lineStatuses = widget.statuses!;
      _isLoading = false;
    } else {
      _loadLines();
    }
  }

  Future<void> _loadLines() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'metro.db');
      if (!await databaseExists(path)) {
        await Directory(dirname(path)).create(recursive: true);
        final data = await rootBundle.load('assets/metro.db');
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes, flush: true);
      }

      final db = await openDatabase(path, readOnly: true);
      var lines = <LineStatusInfo>[];
      try {
        final rows = await db.query('metro_lines');
        lines = rows.map((row) => LineStatusInfo.fromDatabase(row)).toList();
      } finally {
        await db.close();
      }

      if (!mounted) return;
      setState(() {
        _lineStatuses = lines;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Error loading metro lines: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        _loadError = 'Unable to load metro lines.';
        _isLoading = false;
      });
    }
  }

  Widget _buildLineCircle(LineStatusInfo info) {
    final Color statusDotColor =
        info.hasDisruption
            ? const Color(0xFFF97316) // Orange if disrupted
            : const Color(0xFF22C55E); // Green if operational

    return GestureDetector(
      onTap: () => _showLineInfo(info),
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: info.disruptionMessage ?? info.lineName,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 50.0.sp,
              height: 50.0.sp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: info.color,
                shape: BoxShape.circle,
              ),
              child: Text(
                info.lineId.toString(),
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Status dot at bottom right
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14.0,
                height: 14.0,
                decoration: BoxDecoration(
                  color: statusDotColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF161616), // Matches card background
                    width: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildLineInfoSpans(LineStatusInfo info) {
    final spans = <TextSpan>[];

    void addField(String label, String value) {
      spans
        ..add(TextSpan(text: '$label: '))
        ..add(
          TextSpan(
            text: value,
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        )
        ..add(const TextSpan(text: '\n'));
    }

    if (info.name.isNotEmpty) {
      addField('Line', info.name);
    }
    addField('Stations', info.stationCount.toString());
    addField('Interchanges', info.junctionCount.toString());
    if (info.startStation.isNotEmpty) {
      addField('Start', info.startStation);
    }
    if (info.endStation.isNotEmpty) {
      addField('End', info.endStation);
    }
    // if (info.status.isNotEmpty) {
    //   addField('Status', info.status);
    // }
    // if (info.lineCode.isNotEmpty) {
    //   addField('Line code', info.lineCode);
    // }

    if (spans.isNotEmpty && spans.last.text == '\n') {
      spans.removeLast();
    }
    return spans;
  }

  Future<void> _showLineInfo(LineStatusInfo info) async {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                color: info.color,
                padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    children: [TextSpan(text: info.lineName)],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                    children: _buildLineInfoSpans(info),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if any line has a disruption
    final bool anyDisruption = _lineStatuses.any((line) => line.hasDisruption);

    return Scaffold(
      backgroundColor: _screenBg,
      appBar: AppBar(
        backgroundColor: _screenBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 8.0,
        title: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(8.0),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  color: Color.fromARGB(255, 47, 130, 255),
                  size: 18.0,
                ),
                SizedBox(width: 6.0),
                Text(
                  "Done",
                  style: TextStyle(
                    color: Color.fromARGB(255, 47, 130, 255),
                    fontSize: 16.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _loadError != null
                ? Center(
                  child: Text(
                    _loadError!,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large Status Header at Top
                          Text(
                            anyDisruption
                                ? "Disrupted services"
                                : "All services operational",
                            style: TextStyle(
                              color:
                                  anyDisruption
                                      ? const Color(0xFFF97316)
                                      : Colors.white,
                              fontSize: 18.0.sp,
                              fontWeight: FontWeight.w500,
                              // letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          // Container holding all line circles
                          Wrap(
                            spacing: 10.0.sp,
                            runSpacing: 10.0.sp,
                            children:
                                _lineStatuses.map(_buildLineCircle).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Lower section container with "Updates" heading
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 26, 26, 26),
                          // borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Updates",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                fontSize: 18.0.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              anyDisruption
                                  ? "Check individual lines for delay details."
                                  : "No recent service updates.",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                fontSize: 14.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
