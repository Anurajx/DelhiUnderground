import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/StationDir/stopInfo.dart';

class ammenitiesElemenets extends StatefulWidget {
  final stationCode;
  const ammenitiesElemenets({super.key, required this.stationCode});

  @override
  State<ammenitiesElemenets> createState() => _ammenitiesElemenetsState();
}

class _ammenitiesElemenetsState extends State<ammenitiesElemenets> {
  List<dynamic> gatesJson = [];
  @override
  void initState() {
    super.initState();
    loadStationsFromCSV().then((stations) {
      if (mounted) {
        setState(() {
          gatesJson = stations;
          print("JSON OF GATES IS $gatesJson");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //   "TRIAL1 THE STATION CODE IS /// ${widget.stationCode["Source"]["StationCode"]}",
    // );
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
          stationLineBadgeBuilder(gatesJson, widget.stationCode),
        ],
      ),
    );
    //stationLineBadgeBuilder(gatesJson, widget.stationCode);
    // stationList(gatesJson);
  }
}

Future<List> loadStationsFromCSV() async {
  //IF I EVER CHANGE TO JSON CHANGE IT HERE TO MAKE A LIST OUT OF IT
  //fetching data from CSV file logic
  try {
    final jsonRawData = await rootBundle.loadString(
      "assets/Map/parkingjson.json",
    );
    final List<dynamic> jsonList = jsonDecode(jsonRawData);
    print("JSON TRIAL1 RAW DATA IS $jsonList");
    return jsonList;
  } catch (e) {
    return [];
    //error protection
  }
}

// Widget stationList(
//   // widget that is expanded and scrollable of stations at bottom
//   List<dynamic> stations,
//   stationCode,
// ) {
//   //final localStationCode = widget.stationCode;
//   if (stations.isEmpty) {
//     print("JSON TRIAL1 RAW DATA IS EMPTY $stations");
//     return const Center(
//       child: Column(
//         children: [
//           SizedBox(height: 30),
//           //CupertinoActivityIndicator(color: Colors.white, radius: 15),
//           Icon(
//             CupertinoIcons.exclamationmark_circle_fill,
//             color: Color.fromARGB(255, 255, 145, 145),
//           ),
//           Text(
//             "no gates found",
//             style: TextStyle(
//               color: Color.fromARGB(255, 255, 145, 145),
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   return Expanded(
//     child: ListView.separated(
//       itemCount: stations.length,
//       itemBuilder: (context, index) {
//         var station = stations[index];

//         // Defensive check
//         if (station["StationCode"]) {
//           //return const SizedBox();
//           String name = station["Name"]; // Station Name
//           String hindiName = station["Hindi"];
//           return exitBlock(name, hindiName); // or some error placeholder
//         }
//         print("Later JSON station is $station");
//         print("Later JSON station name is ${station["Name"]}");

//         //List<int> lineNumbers = [1, 4];
//         //HARD CODED LINE NUMBERS FOR NOW
//         //print("Line numbers: $lineNumbers");
//         String name = station["Name"]; // Station Name
//         String hindiName =
//             station["Hindi"]; // not hindiName actually hindi name
//         return null;
//       },
//       separatorBuilder: (context, index) {
//         return const Divider(color: Color.fromARGB(255, 27, 27, 27), height: 1);
//       },
//     ),
//   );
// }

Widget stationLineBadgeBuilder(List<dynamic> gates, stationCode) {
  return Column(
    children:
        gates.map<Widget>((line) {
          print(
            "Line TRIAL6 is ${line["station_code"]} AND the station code is $stationCode",
          );
          if (line["station_code"] == stationCode) {
            return ammenitiesBlock(
              line["parking_car"],
              line["parking_motorcycle"],
              line["elevated"],
              line["toilet"],
            );
          } else {
            print("Line TRIAL1 is NOT APPROVED");
            return SizedBox();
          }
          // return Padding(
          //   padding: const EdgeInsets.only(right: 3),
          //   child: exitBlock("GATE", "NEW DOG"),
          // );
        }).toList(),
  );
}

ammenitiesBlock(carSlots, bikeSlots, elevated, washroom) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
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
                              "$carSlots slots",
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
                              "$bikeSlots slots",
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
                "elevated",
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
                "$elevated",
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
                "$washroom",
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
