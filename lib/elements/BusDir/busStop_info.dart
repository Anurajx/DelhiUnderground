import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/ServicesDir/new_schedule_service.dart';
import 'package:metroapp/elements/StationDir/stop_info.dart';
import 'package:metroapp/main.dart';

class StopInfoScreen extends StatefulWidget {
  final int stopId;

  const StopInfoScreen({super.key, required this.stopId});

  @override
  State<StopInfoScreen> createState() => _StopInfoScreenState();
}

class _StopInfoScreenState extends State<StopInfoScreen> {
  DateTime _refreshTrigger = DateTime.now();
  bool _hasTriggeredRefresh = false;
  Map<String, dynamic>? _stop;

  @override
  void initState() {
    super.initState();
    _loadStop();
  }

  Future<void> _loadStop() async {
    try {
      final db = await MetroDbService.getDatabase();
      final rows = await db.query(
        'bus_stop',
        where: 'id = ?',
        whereArgs: [widget.stopId],
        limit: 1,
      );
      if (!mounted) return;
      setState(() {
        _stop = rows.isNotEmpty ? rows.first : null;
      });
    } catch (error) {
      debugPrint('Error loading bus stop ${widget.stopId}: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _stop?['name']?.toString() ?? 'Bus stop';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Transform.translate(
                      offset: Offset(-8.w, 0),
                      child: BackButton(
                        color: AppColors.whiteAccent,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 5.h),
                child: Row(
                  children: [
                    Text(
                      'Realtime Departures',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      CupertinoIcons.antenna_radiowaves_left_right,
                      color: AppColors.secondaryText,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels < -80 &&
                        !_hasTriggeredRefresh) {
                      _hasTriggeredRefresh = true;
                      setState(() => _refreshTrigger = DateTime.now());
                    } else if (notification.metrics.pixels >= 0) {
                      _hasTriggeredRefresh = false;
                    }
                    return false;
                  },
                  child: ListView(
                    padding: EdgeInsets.only(top: 16.h),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      ScheduleWidget(
                        stationCode: widget.stopId.toString(),
                        refreshTrigger: _refreshTrigger,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
