import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class stationUnit extends StatelessWidget {
  final dynamic name;
  final dynamic hindiName;
  final List lines;

  const stationUnit({
    super.key,
    required this.name,
    required this.hindiName,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 60,
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StationNameAndArrow(name),
          commonName(hindiName),
          SizedBox(
            height: 5.h,
          ), //added to even out the padding from top and bottom
          stationLineBadgeBuilder(lines),
        ],
      ),
    );
  }
}

commonName(name) {
  //removing for now but add back when a place has an common name by checking database
  return Row(
    children: [
      Text(
        "$name",
        style: TextStyle(
          fontFamily: 'Poppins',
          color: const Color.fromARGB(255, 141, 141, 141),
          fontSize: 12.sp,
          fontWeight: FontWeight.w200,
        ),
      ),
    ],
  );
}

StationNameAndArrow(name) {
  //for station list in search page
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '$name',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: const Color.fromARGB(255, 179, 179, 179),
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Container( //FOR DMRC logo
      //   height: 15,
      //   width: 15,
      //   margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage('assets/Image/metro.png'),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      Spacer(),
      Icon(
        CupertinoIcons.arrow_right,
        color: const Color.fromARGB(255, 179, 179, 179),
      ),
    ],
  );
}

Color getColorFromLineNumber(int lineNumber) {
  switch (lineNumber) {
    case 1:
      return const Color.fromARGB(255, 209, 52, 56); //red line
    case 2:
      return const Color.fromARGB(255, 200, 155, 0); //yellow line
    case 3:
      return const Color.fromARGB(255, 0, 122, 204); //blue line main
    case 4:
      return const Color.fromARGB(255, 0, 142, 224); //check blue line branch
    case 5:
      return const Color.fromARGB(255, 0, 168, 107); //green line
    case 6:
      return const Color.fromARGB(255, 125, 68, 157); //violet line
    case 7:
      return const Color.fromARGB(255, 219, 112, 147); //pink line
    case 8:
      return const Color.fromARGB(255, 170, 0, 119); //magenta line
    case 9:
      return const Color.fromARGB(255, 130, 130, 130); //grey line
    case 10:
      return const Color.fromARGB(255, 255, 114, 12); //check airport line
    case 15:
      return const Color.fromARGB(255, 0, 185, 235); //rapid metro line
    case 20:
      return const Color.fromARGB(255, 0, 185, 235); //aqua line
    //green line
    default:
      return const Color.fromARGB(226, 255, 255, 255); //default
  }
} //build this line indicator builder tommorow

//9,
Widget stationLineBadgeBuilder(List<dynamic> lines) {
  return Row(
    children:
        lines.map<Widget>((line) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: stationLineBadge(line),
          );
        }).toList(),
  );
}

stationLineBadge(line) {
  //int lineNumber = line[0];
  return Row(
    children: [
      // SizedBox(
      //   width: 10,
      // ), // adding to create a bit of space between line indicatot and text
      Container(
        width: 17.w,
        height: 17.h,
        decoration: BoxDecoration(
          color: getColorFromLineNumber(line),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "$line",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      //SizedBox(width: 10),
    ],
  );
}

class stationPrimitive extends StatelessWidget {
  //for station list on main screen
  final dynamic name;

  const stationPrimitive({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '$name',
            //maxLines: 2,
            overflow: TextOverflow.fade,
            softWrap: false,
            // minFontSize: 14,
            // maxFontSize: 18,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 179, 179, 179),
              fontSize: 18.sp,
              fontWeight: FontWeight.w400, //300
            ),
          ),
        ),
        //Spacer(),
        // Row(
        //   children: [
        //     SizedBox(
        //       width: 10,
        //     ), // adding to create a bit of space between line indicatot and text
        //     Container(
        //       width: 15,
        //       height: 15,
        //       decoration: BoxDecoration(
        //         color: const Color.fromARGB(255, 0, 122, 204),
        //         borderRadius: BorderRadius.all(Radius.circular(3)),
        //       ),
        //       child: Center(
        //         child: Text(
        //           "3",
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 10,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ),
        //       // color: const Color(
        //       //   0xFF0072BC,
        //       // ), //blue line color will make it dynamic later
        //     ),
        //     SizedBox(width: 1),
        //     Container(
        //       width: 15,
        //       height: 15,

        //       decoration: BoxDecoration(
        //         color: const Color.fromARGB(255, 200, 155, 0),
        //         borderRadius: BorderRadius.all(Radius.circular(3)),
        //       ),
        //       child: Center(
        //         child: Text(
        //           "7",
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 10,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ), //make this change dynamically based on the station
        //       // color: const Color(
        //       //   0xFFF47B20,
        //       // ), //blue line color will make it dynamic later
        //     ),
        //   ],
        // ),
        //Spacer(),
        //right: 0,
        Icon(
          CupertinoIcons.arrow_right,
          color: const Color.fromARGB(255, 179, 179, 179),
        ),
      ],
    );
  }
}

class stationNearby extends StatelessWidget {
  //for station list on main screen
  final dynamic name;
  final dynamic line;
  const stationNearby({super.key, required this.name, required this.line});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            '$name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 179, 179, 179),
              fontSize: 18.sp, //18
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        //SizedBox(width: 10),
        //stationLineBadgeBuilder(line),
        // Spacer(),
        Icon(
          Icons.info_outline_rounded,
          color: const Color.fromARGB(255, 179, 179, 179),
        ),
        // Container(
        //   // height: 20,
        //   // width: 50,
        //   padding: const EdgeInsets.all(2.0),
        //   color: const Color.fromARGB(255, 199, 199, 199),
        //   child: Center(
        //     child: Text(
        //       "1.2 KM",
        //       style: TextStyle(
        //         color: const Color.fromARGB(255, 0, 0, 0),
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

///////////////////////
class bigNameInfo extends StatelessWidget {
  final dynamic stationName;
  final dynamic stationNameHindiCommon;
  final dynamic lineofStation;
  const bigNameInfo({
    super.key,
    required this.stationName,
    required this.stationNameHindiCommon,
    required this.lineofStation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(color: const Color.fromARGB(255, 164, 164, 164)),
      //margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      height: 230.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Text(
            "$stationName",
            style: TextStyle(
              height: 1.2,
              color: const Color.fromARGB(255, 240, 240, 240),
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "$stationNameHindiCommon",
            style: TextStyle(
              color: const Color.fromARGB(255, 240, 240, 240),
              fontWeight: FontWeight.w300,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 5.h),
          stationLineBadgeBuilderForBIG(lineofStation),
          Spacer(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

Widget stationLineBadgeBuilderForBIG(List<dynamic> lines) {
  return Row(
    children:
        lines.map<Widget>((line) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: stationLineBadgeForBig(line),
          );
        }).toList(),
  );
}

stationLineBadgeForBig(line) {
  //int lineNumber = line[0];
  return Row(
    children: [
      // SizedBox(
      //   width: 10,
      // ), // adding to create a bit of space between line indicatot and text
      Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: getColorFromLineNumber(line),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "$line",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      //SizedBox(width: 10),
    ],
  );
}
