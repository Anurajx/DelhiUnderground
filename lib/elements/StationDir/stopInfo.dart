import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/ServicesDir/Station_element.dart';
import 'package:metroapp/elements/ServicesDir/gatesFetcher.dart';
import 'package:metroapp/elements/ServicesDir/newScheduleService.dart';
import 'package:metroapp/elements/ServicesDir/openingClosingFetcher.dart';
import 'package:metroapp/elements/ServicesDir/reportErrorService.dart';
import 'package:metroapp/elements/ServicesDir/scheduleService.dart';
import 'package:metroapp/elements/ServicesDir/stopInfoFetcher.dart';
import 'package:metroapp/elements/StationDir/stationSearch.dart';
import 'package:metroapp/elements/route.dart';
import 'package:path/path.dart';
//import 'package:lottie/lottie.dart';

class stopInfoScreen extends StatelessWidget {
  final dynamic stationDict;
  const stopInfoScreen({super.key, required this.stationDict});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: stationCluster(context, stationDict),
    );
  }
}

/////////////////
// class stopInfoScreen extends StatefulWidget {
//   final dynamic stationDict;
//   final station;
//   //final List<dynamic> stationList = [];
//   const stopInfoScreen({super.key, required this.stationDict, this.station});

//   @override
//   State<stopInfoScreen> createState() => _stopInfoScreenState();
// }

// class _stopInfoScreenState extends State<stopInfoScreen> {
//   //final List<dynamic> stationList = stationD;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: stationCluster(context),
//     );
//   }
// }
////////////////////
stationCluster(context, stationDict) {
  final stationCode = stationDict["Source"]["StationCode"];
  print("TRIAL1 THE STATION CODE IS - ${stationDict}");
  return SafeArea(
    child: Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0), //IMPLEMENT ON ALL
      child: Column(
        children: [
          topNavBar(context),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                stationLineMarker(stationDict),
                //SizedBox(height: 100),
                StationTimesWidget(stationCode: stationCode),
                //closeAndOpeningTime(),
                stationStatus(context, stationDict["Source"]["Name"]),
                SizedBox(height: 2.h),

                //toAndFromBlock(),
                SizedBox(height: 40.h),
                gatesElement(station: stationCode),
                SizedBox(height: 40.h),

                //newScheduleBlock(),
                ScheduleWidget(stationCode: stationCode),
                //SchedulePage(stationCode: stationDict["Source"]["StationCode"]),
                //scheduleBlock(),
                //exitBlock(),
                SizedBox(height: 40.h),
                ammenitiesElemenets(stationCode: stationCode),
                //ammenitiesBlock(),
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
  );
}

topNavBar(context) {
  return Container(
    //color: const Color.fromARGB(0, 8, 8, 8),
    //height: 50,
    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
        //
      ],
    ),
  ); //////////////
}

stationLineMarker(stationDict) {
  dynamic station =
      stationDict["Source"]; //uses station to change the name of station dynamically
  String stationName = station["Name"].toString();
  String stationNameHindiCommon = station["Hindi"].toString();
  String line = station["Line"];
  line = line.replaceAll(RegExp(r'[\[\]]'), '');
  List<String> parts = line.split('-');
  List<int> lineNumbers = parts.map((e) => int.parse(e)).toList();
  return bigNameInfo(
    stationName: stationName,
    stationNameHindiCommon: stationNameHindiCommon,
    lineofStation: lineNumbers,
  );
}

closeAndOpeningTime() {
  return Container(
    padding: EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Lottie.asset('assets/Image/radaranim.json', height: 30, width: 35),
        Text(
          "Opens from 06:00 until 23:00",
          style: TextStyle(
            color: const Color.fromARGB(255, 130, 130, 130),
            fontWeight: FontWeight.w500,
          ),
        ),
        //Spacer(),
      ],
    ),
  );
}

stationStatus(BuildContext context, stationName) {
  return Container(
    height: 80.h,
    width: double.infinity,

    //color: Colors.teal,
    child: Row(
      children: [
        Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          width: 90.w,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "QUIET",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                "crowd",
                style: TextStyle(
                  color: const Color.fromARGB(255, 130, 130, 130),
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                //warns user with that BIG GREEN BOX for mis match
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 31, 200, 127),
                      title: Text(
                        "No disruption found on this route",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      content: Text(
                        '$stationName',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      actions: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: const Color.fromARGB(
                              255,
                              255,
                              255,
                              255,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(
                              context,
                            ); //reset just so user does not gets even more confused
                            // controller1.text = ''; //reset
                            // controller2.text = ''; //reset
                          },
                          child: Text(
                            'Okay',
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                        ),
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     backgroundColor: Colors.black,
                        //     foregroundColor: const Color.fromARGB(
                        //       255,
                        //       255,
                        //       255,
                        //       255,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       CupertinoPageRoute(
                        //         builder:
                        //             (context) => routeScreen(
                        //               coreTransferStationsDict:
                        //                   coreTransferStationsDict,
                        //             ),
                        //       ),
                        //     );
                        //   },
                        //   child: Text(
                        //     'Continue',
                        //     style: TextStyle(fontFamily: "Poppins"),
                        //   ),
                        // ),
                      ],
                    ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              color: const Color.fromARGB(255, 25, 25, 25),
              //width: 90,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "NO DISRUPTION",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward, color: Colors.green, size: 20),
                    ],
                  ),
                  Text(
                    "check details",
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

toAndFromBlock() {
  return Container(
    height: 70.h,
    width: double.infinity,
    //color: Colors.teal,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 207, 207, 207),
            width: 90.w,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "GO TO",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_downward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  "this station",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
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
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 207, 207, 207),
            width: 90.w,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "GET FROM",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_upward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  "this station",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
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

exitBlock() {
  //EXIT BLOCK UNDERPROGRESS
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "EXIT",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16.sp, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Palika Bhawan, RK Puram Sector-13, New Delhi",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 232, 232, 232),
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
                //color: Color.fromARGB(255, 0, 0, 0),
                border: Border.all(
                  color: const Color.fromARGB(255, 25, 25, 25),
                ),
              ),
              //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Center(
                child: Text(
                  "GATE 1",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 172, 172, 172),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        ////////////////////////////////////////
        SizedBox(height: 2.h),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "DTC Sarojini Nagar Depot",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 182, 182, 182),
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
                //color: Color.fromARGB(255, 0, 0, 0),
                border: Border.all(
                  color: const Color.fromARGB(255, 25, 25, 25),
                ),
              ),
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Center(
                child: Text(
                  "GATE 2",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 172, 172, 172),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
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
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "EIL,Hyatt Regency, Gail India Ltd",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 182, 182, 182),
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
                //color: Color.fromARGB(255, 0, 0, 0),
                border: Border.all(
                  color: const Color.fromARGB(255, 25, 25, 25),
                ),
              ),
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Center(
                child: Text(
                  "GATE 3",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 172, 172, 172),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          //image with visualize of map blocl
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 90.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              image: AssetImage("assets/Image/mapimg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: [
              Text(
                "VIEW ON MAP",
                style: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
            ],
          ),
        ),
        ////////
      ],
    ),
  );
}

newScheduleBuilder() {
  return Container(
    child: Row(
      children: [newScheduleBlock(), SizedBox(width: 2.w), newScheduleBlock()],
    ),
  );
}

newScheduleBlock() {
  return Expanded(
    child: Container(
      //height: 150.h,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                padding: EdgeInsets.all(15.sp),
                color: const Color.fromARGB(255, 33, 33, 33),
                width: double.infinity,
                child: Text(
                  "Majlis Park",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(color: Colors.pinkAccent, height: 10.h, width: 10.w),
            ],
          ),
          Container(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "10:00 AM",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "5 Min",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "10:00 AM",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "5 Min",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

scheduleBlock() {
  //schedule
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "SCHEDULE",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16.sp, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        newScheduleBuilder(),
      ],
    ),
  );
}

ammenitiesBlock() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "INFORMATION",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16.sp, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          //height: 90.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
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
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 207, 207, 207),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "available",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 14, 14, 14),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "30 slots",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Spacer(),
              Image.asset(
                "assets/Image/carinf.jpeg",
                height: 80.h, //prev 80
                width: 130.w,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          //height: 80.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
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
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 207, 207, 207),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "unavailable",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 14, 14, 14),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "0 slots",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 207, 207, 207),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
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
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 50.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              //SizedBox(width: 10),
              Text(
                "elevator",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                ">",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                "available",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Spacer(),
              // Image.asset(
              //   "assets/Image/elevatorinf.jpeg",
              //   height: 80,
              //   width: 130,
              //   fit: BoxFit.cover,
              // ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 50.h,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              //SizedBox(width: 10),
              Text(
                "washroom",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                ">",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                "available",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Image.asset(
              //   "assets/Image/washroominf.jpeg",
              //   height: 80,
              //   width: 130,
              //   fit: BoxFit.cover,
              // ),
            ],
          ),
        ),
      ],
    ),
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
            fontWeight: FontWeight.w800,
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
