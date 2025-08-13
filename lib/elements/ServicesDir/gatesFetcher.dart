import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/StationDir/stopInfo.dart';

class gatesElement extends StatefulWidget {
  final station;
  const gatesElement({super.key, required this.station});

  @override
  State<gatesElement> createState() => _gatesElementState();
}

class _gatesElementState extends State<gatesElement> {
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
    //   "TRIAL1 THE STATION CODE IS /// ${widget.station["Source"]["StationCode"]}",
    // );
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
          stationLineBadgeBuilder(gatesJson, widget.station),
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
      "assets/Map/gatesjson.json",
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
            "Line TRIAL1 is ${line["Station Code Name"]} AND the station code is $stationCode",
          );
          if (line["Station Code Name"] == stationCode) {
            print("Fcukkkkk yeah");
            return exitBlock(line["Gate Name"], line["Location"]);
          } else {
            print(" Fcukkkkk yeahhellll naahhh");
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

exitBlock(gateNo, gateName) {
  //EXIT BLOCK UNDERPROGRESS
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
                              "${gateName.toString().toLowerCase()}",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
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
                  "$gateNo",
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 233, 233, 233),
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
        // Container(
        //   //image with visualize of map blocl
        //   padding: EdgeInsets.all(10),
        //   width: double.infinity,
        //   height: 90.h,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        //       image: AssetImage("assets/Image/mapimg.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   child: Row(
        //     children: [
        //       Text(
        //         "VIEW ON MAP",
        //         style: TextStyle(
        //           color: const Color.fromARGB(255, 179, 179, 179),
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //       Spacer(),
        //       Icon(
        //         Icons.chevron_right,
        //         color: const Color.fromARGB(255, 179, 179, 179),
        //       ),
        //     ],
        //   ),
        // ),
        ////////
      ],
    ),
  );
}
