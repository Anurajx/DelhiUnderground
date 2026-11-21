import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/ServicesDir/report_error_service.dart';
import 'package:metroapp/main.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ---------------------- DB SERVICE ----------------------

String formatRouteStationName(String stationName) {
  final trimmedName = stationName.trim();
  if (trimmedName.isEmpty) return '';
  return '${trimmedName[0].toUpperCase()}${trimmedName.substring(1).toLowerCase()}';
}

class RouteService {
  Future<Map<String, dynamic>?> getRouteFromDict(
    Map<String, dynamic> input,
  ) async {
    try {
      final sourceCode = input["Source"]["StationCode"].toString();
      final destCode = input["Destination"]["StationCode"].toString();
      final routeType =
          input["RouteType"] == "minimum-interchange"
              ? "minimum-interchange"
              : "least-distance";

      final uri = Uri(
        scheme: 'http',
        host: 'delhiplatform.duckdns.org',
        port: 3000,
        path: '/api/DMRC_route',
        queryParameters: {
          'fromCode': sourceCode,
          'toCode': destCode,
          'routeType': routeType,
          'time': DateTime.now().toIso8601String(),
        },
      );

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(uri);
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      client.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint('DMRC route API error: ${response.statusCode} $body');
        return null;
      }

      final responseData = jsonDecode(body) as Map<String, dynamic>;
      final apiRoute =
          (responseData['route'] as List<dynamic>? ?? const [])
              .whereType<Map>()
              .map<Map<String, dynamic>>((leg) {
                final legData = Map<String, dynamic>.from(leg);
                final path =
                    (legData['path'] as List<dynamic>? ?? const [])
                        .whereType<Map>()
                        .map(
                          (station) => formatRouteStationName(
                            station['name']?.toString() ?? '',
                          ),
                        )
                        .where((name) => name.isNotEmpty)
                        .toList();
                final lineName = legData['line']?.toString() ?? '';
                final lineColor = lineName.replaceAll(
                  RegExp(r'\s*Line\s*$', caseSensitive: false),
                  '',
                );
                final start =
                    legData['start']?.toString() ??
                    (path.isNotEmpty ? path.first : '');
                final end =
                    legData['towards_station']?.toString() ??
                    (legData['end']?.toString() ?? '');

                return {
                  'line_name':
                      '${formatRouteStationName(start)} to ${formatRouteStationName(end)}',
                  'line_color': lineColor,
                  'stops': path,
                  'station_interchange_time':
                      (legData['station_interchange_time'] ?? 0),
                  'platform_name': legData['platform_name']?.toString() ?? '',
                };
              })
              .toList();

      final interchanges = apiRoute.length > 1 ? apiRoute.length - 1 : 0;
      final totalTime = _parseApiDuration(
        responseData['total_time']?.toString(),
      );
      final fare =
          (responseData['fare'] is num)
              ? responseData['fare'] as num
              : num.tryParse(responseData['fare']?.toString() ?? '') ?? 0;

      return {
        'start': formatRouteStationName(
          responseData['from']?.toString() ??
              input["Source"]["Name"]?.toString() ??
              '',
        ),
        'end': formatRouteStationName(
          responseData['to']?.toString() ??
              input["Destination"]["Name"]?.toString() ??
              '',
        ),
        'time': totalTime,
        'interchanges': interchanges,
        'price': fare,
        'route_data': {'legs': apiRoute},
      };
    } catch (error, stackTrace) {
      debugPrint('Error fetching DMRC route: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  int _parseApiDuration(String? duration) {
    if (duration == null || duration.isEmpty) return 0;
    final parts = duration.split(':');
    if (parts.isEmpty) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final seconds = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return hours * 60 + minutes + (seconds > 0 ? 1 : 0);
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
                ? _RouteLoadingSkeleton(
                  context: context,
                  coreTransferStationsDict: widget.coreTransferStationsDict,
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

class _RouteLoadingSkeleton extends StatelessWidget {
  final BuildContext context;
  final Map<String, dynamic> coreTransferStationsDict;

  const _RouteLoadingSkeleton({
    required this.context,
    required this.coreTransferStationsDict,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        children: [
          topNavBar(context, coreTransferStationsDict),
          Skeletonizer(
            enabled: true,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    'Your trip takes 49 Minutes has 1 interchange and costs 54 Rs.',
                    style: TextStyle(
                      color: AppColors.tertiaryText,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 35, 35, 35),
                ),
                SizedBox(height: 50.sp),
                Center(
                  child: SizedBox(
                    width: 100.sp,
                    child: LinearProgressIndicator(
                      color: Colors.blueAccent,
                      year2023: false,
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
}

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
    print("TEST125: ${routeInfo['route_data']['legs'].length}");
    print("TEST125: ${routeInfo['route_data']['legs'][0]}");

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        children: [
          topNavBar(context, coreTransferStationsDict),
          TripSummary(
            totalTime: routeInfo['time'],
            interchanges: routeInfo['interchanges'],
            price: routeInfo['price'] ?? 0,
          ),
          const Divider(thickness: 1, color: Color.fromARGB(255, 35, 35, 35)),

          // Expandable area
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
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
                          Column(
                            children: List.generate(
                              routeInfo['route_data']['legs'].length * 2 - 1,
                              (index) {
                                if (index.isEven) {
                                  final legIndex = index ~/ 2;
                                  final leg =
                                      routeInfo['route_data']['legs'][legIndex];
                                  return RouteCluster(
                                    lineColor: leg['line_color'],
                                    startStation: routeInfo['start'],
                                    endStation: routeInfo['end'],
                                    stations: leg,
                                  );
                                } else {
                                  final nextLegIndex = (index ~/ 2) + 1;
                                  final nextLeg =
                                      routeInfo['route_data']['legs'][nextLegIndex];
                                  return interchangeInfo(
                                    nextLeg['station_interchange_time'],
                                  );
                                }
                              },
                            ),
                          ),

                          // Spacer pushes footer down when space available
                          const Spacer(),

                          const SizedBox(height: 40),
                          // Footer inside the container
                          Column(
                            children: [
                              reportError(),
                              const SizedBox(height: 20),
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
  final routeLabel =
      coreTransferStationsDict['RouteType'] == 'minimum-interchange'
          ? 'Least Interchange'
          : 'Fastest Route';

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
        Icon(
          CupertinoIcons.hare_fill,
          color: Color.fromARGB(255, 126, 126, 126),
          size: 18.sp,
        ),
        const SizedBox(width: 5),
        Text(
          routeLabel,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 126, 126, 126),
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),

        //  Marquee(
        //   text:
        //       "${coreTransferStationsDict['Source']["Name"]} → ${coreTransferStationsDict['Destination']["Name"]}",
        //   showFadingOnlyWhenScrolling: true,
        //   fadingEdgeStartFraction: 0.2,
        //   fadingEdgeEndFraction: 0.1,
        //   blankSpace: 20,
        //   style: TextStyle(
        //     fontFamily: 'Poppins',
        //     color: Color.fromARGB(255, 202, 202, 202),
        //     fontSize: 16.sp,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
      ],
    ),
  );
}

class TripSummary extends StatelessWidget {
  final int totalTime;
  final int interchanges;
  final num price;

  const TripSummary({
    super.key,
    required this.totalTime,
    required this.interchanges,
    required this.price,
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
              text: " has ",
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
            TextSpan(
              text: "and costs ",
              style: TextStyle(
                color: AppColors.tertiaryText,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "${price.toString().replaceAll(RegExp(r'\.0+$'), '')} Rs.",
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

class RouteCluster extends StatefulWidget {
  final String lineColor;
  final String startStation;
  final String endStation;
  final Map<String, dynamic> stations;

  const RouteCluster({
    super.key,
    required this.lineColor,
    required this.startStation,
    required this.endStation,
    required this.stations,
  });

  @override
  State<RouteCluster> createState() => _RouteClusterState();
}

class _RouteClusterState extends State<RouteCluster> {
  int extraStations = 0;
  double stationHeight = 25.h;
  double height =
      220.h; //presetting height at one place so that text and line indicator stay at same height
  double collapsableHeight = 30.h;
  double collapsableWidth = 150.w;
  bool isExpanded = false;
  void _containerToggle() {
    // print("TEST5244${widget.stations["stops"]}");
    setState(() {
      isExpanded = !isExpanded;
      extraStations = widget.stations['stops'].length;
      // print(isExpanded);
      if (isExpanded) {
        collapsableHeight =
            0.h +
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
            LineIndicator(
              height: height,
              lineColor: widget.lineColor,
              extraStations: 5,
            ),
            Expanded(
              child: InfoIndicator(
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
                legs: widget.stations,
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

class InfoIndicator extends StatefulWidget {
  final double height;
  final double collapsableWidth;
  final double collapsableHeight;
  final bool isExpanded;
  final String start;
  final String end;
  final Map<String, dynamic> legs;

  const InfoIndicator({
    super.key,
    required this.height,
    required this.collapsableHeight,
    required this.collapsableWidth,
    required this.isExpanded,
    required this.start,
    required this.end,
    required this.legs,
  });

  @override
  State<InfoIndicator> createState() => _InfoIndicatorState();
}

class _InfoIndicatorState extends State<InfoIndicator> {
  @override
  Widget build(BuildContext context) {
    String heading = formatRouteStationName(
      widget.legs['line_name'].toString().split(" to ").last.trim(),
    );
    final platformName = widget.legs['platform_name']?.toString().trim() ?? '';
    String colorName = widget.legs['line_color'].toString().toLowerCase();
    String StartStnName = formatRouteStationName(
      widget.legs['stops'][0].toString(),
    );
    String EndStnName = formatRouteStationName(
      widget.legs['stops'][widget.legs['stops'].length - 1].toString(),
    );
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 19, 19, 19),
                    // borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    platformName.isNotEmpty ? platformName : 'Platform',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 148, 8),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  " ${colorName} line",
                  style: TextStyle(
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
            " Towards ${heading}",
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
                widget.legs['stops'],
              ) //add the collapsed station expanded display logo
              : Row(
                children: [
                  Text(
                    "${widget.legs['stops'].length - 2} Stations",
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

class LineIndicator extends StatefulWidget {
  final double height;
  final int extraStations;
  final double stationHeight;
  final String lineColor;

  LineIndicator({
    super.key,
    required this.height,
    required this.lineColor,
    required this.extraStations,
  }) : stationHeight = 5.h;

  @override
  State<LineIndicator> createState() => _LineIndicatorState();
}

class _LineIndicatorState extends State<LineIndicator> {
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

interchangeInfo(dynamic interchangeTime) {
  final interchangeMinutes =
      interchangeTime is num
          ? interchangeTime
          : num.tryParse(interchangeTime?.toString() ?? '') ?? 0;
  final formattedTime = interchangeMinutes.toString().replaceAll(
    RegExp(r'\.0+$'),
    '',
  );
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
                        "$formattedTime Min",
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
  //List<String> middleStations = insideStations.sublist(1, insideStations.length - 1);
  List<dynamic> middleStations = insideStations.sublist(
    1,
    insideStations.length - 1,
  );
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
        middleStations
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
                      formatRouteStationName(station.toString()),
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
          onTap: () {
            try {
              sendToGoogleForm();
            } catch (e) {
              debugPrint("Error sending email: $e");
            }
          },
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
