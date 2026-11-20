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
  final bool hasDisruption;
  final String? disruptionMessage;

  const LineStatusInfo({
    required this.lineId,
    required this.lineName,
    required this.color,
    this.hasDisruption = false,
    this.disruptionMessage,
  });

  factory LineStatusInfo.fromDatabase(Map<String, dynamic> row) {
    final lineId = row['id'] as int;
    final lineName = row['line_color_verbose'] as String;
    final colorCode = row['primary_color_code'] as String;
    return LineStatusInfo(
      lineId: lineId,
      lineName: lineName,
      color: Color(int.parse(colorCode.substring(1), radix: 16) | 0xFF000000),
    );
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
  static const Color _headerText = Color.fromARGB(255, 109, 109, 109);

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

    return Tooltip(
      message: info.disruptionMessage ?? info.lineName,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: info.color,
              shape: BoxShape.circle,
            ),
            child: Text(
              info.lineId.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w700,
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
                  color: Colors.white70,
                  size: 18.0,
                ),
                SizedBox(width: 6.0),
                Text(
                  "Done",
                  style: TextStyle(
                    color: _headerText,
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
                        horizontal: 16.0,
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
                              fontSize: 22.0.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24.0),

                          // Container holding all line circles
                          Wrap(
                            spacing: 14.0,
                            runSpacing: 14.0,
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
                          color: const Color.fromARGB(255, 234, 234, 234),
                          // borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Updates",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
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
                                color: const Color.fromARGB(255, 0, 0, 0),
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
