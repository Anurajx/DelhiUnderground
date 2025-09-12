import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:metroapp/elements/ServicesDir/minimetroStationList.dart';
import 'package:metroapp/main.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ---------------------- DB SERVICE ----------------------

class RouteService {
  Database? _db;

  Future<void> initDB() async {
    if (_db != null) return;

    // App documents path
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "routes.db");

    // Check if the database already exists
    final exists = await databaseExists(path);

    if (!exists) {
      // Copy from assets to the path
      ByteData data = await rootBundle.load("assets/routes.db");
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open database
    _db = await openDatabase(path, readOnly: true);
  }

  Future<String> _resolveStationName(String stationCode) async {
    try {
      final jsonData = await rootBundle.loadString(
        'assets/Map/GTFS_StopsForDataRefrenceForDataMismatch.json',
      );
      final List<dynamic> stops = jsonDecode(jsonData);
      for (var stop in stops) {
        if (stop['stationCode']?.toString().toLowerCase() ==
            stationCode.toLowerCase()) {
          return stop['stop_name'];
        }
      }
    } catch (e) {
      debugPrint("Error resolving station code: $e");
    }
    return stationCode;
  }

  Future<Map<String, dynamic>?> getRouteFromDict(
    Map<String, dynamic> input,
  ) async {
    await initDB();

    final sourceCode = input["Source"]["StationCode"];
    final destCode = input["Destination"]["StationCode"];

    final startStation = await _resolveStationName(sourceCode);
    final endStation = await _resolveStationName(destCode);

    final result = await _db!.query(
      "routes",
      where: "start_station_name = ? AND end_station_name = ?",
      whereArgs: [startStation, endStation],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final row = result.first;
      print("TEST123: ${jsonDecode(row["route_data"] as String)}");
      return {
        "start": row["start_station_name"],
        "end": row["end_station_name"],
        "time": row["total_time_minutes"],
        "interchanges": row["interchange_count"],
        "price": row["price"],
        "route_data": jsonDecode(row["route_data"] as String),
      };
    }
    return null;
  }
}

// ---------------------- MAIN SCREEN ----------------------

class RouteScreenNew extends StatefulWidget {
  final Map<String, dynamic> coreTransferStationsDict;

  const RouteScreenNew({super.key, required this.coreTransferStationsDict});

  @override
  State<RouteScreenNew> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreenNew> {
  Map<String, dynamic>? routeInfo;
  final RouteService _routeService = RouteService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await _routeService.getRouteFromDict(
        widget.coreTransferStationsDict,
      );
      setState(() {
        routeInfo = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body:
            (routeInfo == null)
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
                : RouteDisplay(
                  coreTransferStationsDict: widget.coreTransferStationsDict,
                  routeInfo: routeInfo!,
                ),
      ),
    );
  }
}

// ---------------------- UI ----------------------

class RouteDisplay extends StatelessWidget {
  final dynamic coreTransferStationsDict;
  final Map<String, dynamic> routeInfo;

  const RouteDisplay({
    super.key,
    required this.coreTransferStationsDict,
    required this.routeInfo,
  });

  @override
  Widget build(BuildContext context) {
    print("TEST123: ${routeInfo['route_data']}");
    //print("TEST123: ${routeInfo['route_data']?['legs'][0]['stops'][0]}");
    //final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        children: [
          topNavBar(context, coreTransferStationsDict),
          TripSummary(
            totalTime: routeInfo['time'],
            interchanges: routeInfo['interchanges'],
          ),
          Divider(thickness: 1, color: Color.fromARGB(255, 35, 35, 35)),

          // Expandable area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    // force at least full height
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Scrollable content
                          routeCluster(
                            lineColor: "Blue Line",
                            startStation: routeInfo['start'],
                            endStation: routeInfo['end'],
                            stations: (routeInfo['route_data'] ?? []),
                          ),
                          interchangeInfo(),
                          routeCluster(
                            lineColor: "Blue Line",
                            startStation: routeInfo['start'],
                            endStation: routeInfo['end'],
                            stations: (routeInfo['route_data'] ?? []),
                          ),

                          // Spacer pushes footer down when space available
                          Spacer(),

                          SizedBox(height: 40),
                          // Footer inside the container
                          Column(
                            children: [
                              reportError(),
                              SizedBox(height: 20),
                              companyFooter(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

topNavBar(context, coreTransferStationsDict) {
  return Container(
    //color: Colors.white,
    width: double.infinity,
    height: 50.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            HitTestBehavior.opaque;
            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.back,
                color: const Color.fromARGB(255, 47, 130, 255),
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
        Spacer(),
        Container(
          width: 200.w,
          child: Marquee(
            text:
                "${coreTransferStationsDict['Source']["Name"]} → ${coreTransferStationsDict['Destination']["Name"]}",
            showFadingOnlyWhenScrolling: true,
            fadingEdgeStartFraction: 0.2,
            fadingEdgeEndFraction: 0.1,
            blankSpace: 20,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 202, 202, 202),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

class TripSummary extends StatelessWidget {
  final int totalTime;
  final int interchanges;

  const TripSummary({
    super.key,
    required this.totalTime,
    required this.interchanges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Your trip takes ",
              style: TextStyle(
                color: AppColors.tertiaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "${totalTime} Minutes ", //make these a variable
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "and has ",
              style: TextStyle(
                color: AppColors.tertiaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "${interchanges} interchange ",
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class routeCluster extends StatefulWidget {
  final String lineColor;
  final String startStation;
  final String endStation;
  final Map<String, dynamic> stations;

  const routeCluster({
    super.key,
    required this.lineColor,
    required this.startStation,
    required this.endStation,
    required this.stations,
  });

  @override
  State<routeCluster> createState() => _routeClusterState();
}

class _routeClusterState extends State<routeCluster> {
  int extraStations = minimetroStations.length;
  double stationHeight = 25.h;
  double height =
      220.h; //presetting height at one place so that text and line indicator stay at same height
  double collapsableHeight = 30.h;
  double collapsableWidth = 150.w;
  bool isExpanded = false;
  void _containerToggle() {
    setState(() {
      isExpanded = !isExpanded;
      print(isExpanded);
      if (isExpanded) {
        collapsableHeight =
            20.h +
            extraStations * stationHeight; //collapsed and increased height
        collapsableWidth = 250.w; //collapsed and increased width
        height = height + collapsableHeight;
        //height = height + collapsableHeight;
      } else {
        collapsableWidth = 150.w;
        height = height - collapsableHeight;
        //collapsableHeight = 30;
        //height = height - collapsableHeight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromARGB(255, 16, 16, 16),
      highlightColor: const Color.fromARGB(255, 0, 0, 0),
      onTap: _containerToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: height,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            lineIndicator(
              height: height,
              lineColor: widget.stations['legs'][0]['line_color'],
              extraStations: 5,
            ),
            Expanded(
              child: infoIndicator(
                start: widget.startStation,
                end: widget.endStation,
                height: height,
                collapsableHeight: collapsableHeight,
                collapsableWidth: collapsableWidth,
                isExpanded: isExpanded,
                // heading:
                //     widget.stations['legs'][0]['line_name']
                //         .toString()
                //         .split("to")
                //         .last
                //         .trim(), //gives only heading part
                // colorName:
                //     widget.stations['legs'][0]['line_color']
                //         .toString()
                //         .toLowerCase(),
                legs: widget.stations['legs'],
              ),
            ),
            // InkWell(
            //   child: //bar line indicator on left
            //       Expanded(child: infoIndicator(height: height)),
            // ), //station info and other info on right
          ],
        ),
      ),
    );
  }
}

class infoIndicator extends StatefulWidget {
  double height;
  double collapsableWidth = 150.w;
  double collapsableHeight = 30.h;
  bool isExpanded;
  String start;
  String end;
  // String heading;
  // String colorName;
  List legs;
  infoIndicator({
    super.key,
    required this.height,
    required this.collapsableHeight,
    required this.collapsableWidth,
    required this.isExpanded,
    required this.start,
    required this.end,
    // required this.heading,
    // required this.colorName,
    required this.legs,
  });

  @override
  State<infoIndicator> createState() => _infoIndicatorState();
}

class _infoIndicatorState extends State<infoIndicator> {
  @override
  Widget build(BuildContext context) {
    String heading =
        widget.legs[0]['line_name'].toString().split(" to ").last.trim();
    String colorName = widget.legs[0]['line_color'].toString().toLowerCase();
    String StartStnName = widget.legs[0]['stops'][0];
    String EndStnName =
        widget.legs[0]['stops'][widget.legs[0]['stops'].length - 1];
    print("TEST525 $StartStnName to $EndStnName"); //First leg of route
    //right line info
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      height: widget.height,
      //decoration: BoxDecoration(color: const Color.fromARGB(255, 93, 93, 93)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                //heading
                "${StartStnName}", //-------------------HERE--------------------------------------------
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(Icons.login_rounded, color: AppColors.primaryText, size: 20),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            //train heading info
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.train_style_two,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  " Heading towards ${heading}",
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    overflow: TextOverflow.visible,
                    color: AppColors.secondaryText,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "${colorName} line",
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          // Text(
          //   "Every 2 min",
          //   style: TextStyle(
          //     color: AppColors.secondaryText,
          //     fontSize: 15.sp,
          //     fontWeight: FontWeight.w300,
          //   ),
          // ),
          //SizedBox(height: 10),
          Spacer(),
          (widget.isExpanded == true)
              ? collapsedExpandedView(
                widget.legs[0]['stops'],
              ) //add the collapsed station expanded display logo
              : Row(
                children: [
                  Text(
                    "${widget.legs[0]['stops'].length - 2} Stations",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(CupertinoIcons.sort_down, color: Colors.grey, size: 20),
                ],
              ),
          Spacer(), //SPACERRRR
          Row(
            children: [
              Text(
                //heading
                "${EndStnName}",
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.logout_rounded,
                color: AppColors.primaryText,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    ); ////
  }
}

class lineIndicator extends StatefulWidget {
  double height = 250.h;
  int extraStations = 0;
  double stationHeight = 5.h;
  String lineColor;
  lineIndicator({
    super.key,
    required this.height,
    required this.lineColor,
    required this.extraStations,
  });

  @override
  State<lineIndicator> createState() => _lineIndicatorState();
}

class _lineIndicatorState extends State<lineIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: 7.w,
      height: widget.height,
      decoration: BoxDecoration(
        color: _getLineColor(
          widget.lineColor,
        ), //impllemt line color to change dynamically
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
        ],
      ),
    );
  }
}

Color _getLineColor(String lineColor) {
  switch (lineColor.toUpperCase()) {
    case 'RED':
      return Colors.red;
    case 'BLUE':
      return Colors.blue;
    case 'GREEN':
      return Colors.green;
    case 'YELLOW':
      return Colors.yellow;
    case 'PURPLE':
      return Colors.purple;
    case 'PINK':
      return Colors.pink;
    case 'ORANGE':
      return Colors.orange;
    case 'CYAN':
      return Colors.cyan;
    case 'GREY':
      return Colors.grey;
    case 'VIOLET':
      return Colors.deepPurple;
    case 'MAGENTA':
      return Colors.pinkAccent;
    default:
      return Colors.blueAccent;
  }
}

interchangeInfo() {
  return Container(
    height: 70.h,
    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
    width: double.infinity,
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 54, 54, 54)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 7.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(0, 80, 80, 80),
                const Color.fromARGB(255, 200, 200, 200),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make transfer",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 2.h),
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.directions_walk, color: Colors.grey, size: 15),
                      Text(
                        "5 Min",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

collapsedExpandedView(insideStations) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
        insideStations
            .map((station) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_right_rounded,
                      color: Colors.grey,
                      size: 15,
                    ),
                    SizedBox(width: 8),
                    Text(
                      station,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            })
            .toList()
            .cast<Widget>(),
  );
}

reportError() {
  return Row(
    children: [
      Container(
        height: 50.h,
        width: 170.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          //color: const Color.fromARGB(255, 17, 17, 17),
          border: Border.all(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
        child: GestureDetector(
          behavior:
              HitTestBehavior
                  .opaque, // to make sure that when tapped on white space the button is tapped
          onTap: () {},
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "report error",
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 187, 187),
                fontSize: 18.sp, //processedFontheight(context),
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

companyFooter() {
  return Container(
    decoration: BoxDecoration(
      //color: const Color.fromARGB(255, 11, 11, 11),
      //borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    width: double.infinity,
    height: 50.h,
    //color: const Color.fromARGB(255, 57, 57, 57),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "DELHI\nUNDERGROUND",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.h,
            color: const Color.fromARGB(255, 90, 90, 90),
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
        // Text(
        //   "From New Delhi",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: Colors.grey,
        //     fontWeight: FontWeight.w300,
        //     fontSize: 12,
        //   ),
        // ),
      ],
    ),
  );
}
