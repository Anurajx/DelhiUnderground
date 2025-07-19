import 'dart:ffi';
import 'package:marquee/marquee.dart';
import 'package:neopop/neopop.dart';

import './ServicesDir/Station_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ServicesDir/Station_element.dart';
import './ServicesDir/minimetroStationList.dart';

class routeScreen extends StatefulWidget {
  //final Map<String, Map<String, dynamic>> coreTransferStationsDict;
  final Map<String, List<dynamic>>
  coreTransferStationsDict; //temprory, this will have to go though the search alorithm than it will send data here. not directly
  const routeScreen({super.key, required this.coreTransferStationsDict});

  @override
  State<routeScreen> createState() => _routeScreenState();
}

class _routeScreenState extends State<routeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 8, 8, 8),
        body: RouteDisplay(), //temprory
      ),
    );
  }
}

class RouteDisplay extends StatelessWidget {
  const RouteDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          topNavBar(context),
          tripSummary(),
          Divider(thickness: 1, color: const Color.fromARGB(255, 35, 35, 35)),
          Expanded(
            // to give scroll behaviour
            child: ListView(
              shrinkWrap: true,
              children: [
                routeCluster(lineColor: "DOES NOT DO ANYTHING"),
                interchangeInfo(),
                routeCluster(lineColor: "DOES NOT DO ANYTHING"),
                SizedBox(height: 40),
                reportError(),
                SizedBox(height: 40),
                companyFooter(),
              ],
            ),
          ),
          // routeCluster(),
          //Cancel button and option selector
          //Route summary
          //Actual route
        ],
      ),
    );
  }
}

topNavBar(context) {
  return Container(
    //color: Colors.white,
    width: double.infinity,
    height: 50,
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
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          width: 200,
          child: Marquee(
            text: "BHIKAJI CAMA PLACE -> RAJORI GARDEN",
            blankSpace: 20,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color.fromARGB(255, 202, 202, 202),
              fontSize: 12,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
        // Text(
        //   "BHIKAJI CAMA PLACE ",
        //   style: TextStyle(
        //     color: const Color.fromARGB(255, 255, 255, 255),
        //     fontWeight: FontWeight.w500,
        //     fontFamily: 'Poppins',
        //     fontSize: 12,
        //   ),
        // ),
        // Icon(
        //   CupertinoIcons.arrow_right,
        //   color: const Color.fromARGB(255, 255, 255, 255),
        //   size: 15,
        // ),
        // Text(
        //   " RAJORI GARDEN",
        //   style: TextStyle(
        //     color: const Color.fromARGB(255, 255, 255, 255),
        //     fontWeight: FontWeight.w500,
        //     fontFamily: 'Poppins',
        //     fontSize: 12,
        //   ),
        // ),
      ],
    ),
  );
}

class tripSummary extends StatelessWidget {
  //full bottom part comes under this
  const tripSummary({super.key});

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
                color: const Color.fromARGB(255, 109, 109, 109),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "50 Minutes ", //make these a variable
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 187, 187),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "has ",
              style: TextStyle(
                color: const Color.fromARGB(255, 109, 109, 109),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "2 interchange ",
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 187, 187),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "and costs ",
              style: TextStyle(
                color: const Color.fromARGB(255, 109, 109, 109),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "50 Rs. ",
              style: TextStyle(
                color: const Color.fromARGB(255, 187, 187, 187),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// routeCluster(lineColor) {
//   //here both the left line indicator and right info indicator are combined

// }

class routeCluster extends StatefulWidget {
  dynamic lineColor;
  routeCluster({super.key, required this.lineColor});

  @override
  State<routeCluster> createState() => _routeClusterState();
}

class _routeClusterState extends State<routeCluster> {
  // combines both line indicator and info indicator

  int extraStations = minimetroStations.length;
  double stationHeight = 25;
  double height =
      250; //presetting height at one place so that text and line indicator stay at same height
  double collapsableHeight = 30;
  double collapsableWidth = 150;
  bool isExpanded = false;
  void _containerToggle() {
    setState(() {
      isExpanded = !isExpanded;
      print(isExpanded);
      if (isExpanded) {
        collapsableHeight =
            20 + extraStations * stationHeight; //collapsed and increased height
        collapsableWidth = 250; //collapsed and increased width
        height = height + collapsableHeight;
        //height = height + collapsableHeight;
      } else {
        collapsableWidth = 150;
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
              lineColor: widget.lineColor,
              extraStations: 5,
            ),
            Expanded(
              child: infoIndicator(
                height: height,
                collapsableHeight: collapsableHeight,
                collapsableWidth: collapsableWidth,
                isExpanded: isExpanded,
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

// lineIndicator(height, lineColor) {
// }

class lineIndicator extends StatefulWidget {
  double height = 250;
  int extraStations = 0;
  double stationHeight = 5;
  dynamic lineColor;
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
      width: 7,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.blueAccent, //impllemt line color to change dynamically
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
          Container(
            width: 6,
            height: 6,
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

class infoIndicator extends StatefulWidget {
  double height;
  double collapsableWidth = 150;
  double collapsableHeight = 30;
  bool isExpanded;
  infoIndicator({
    super.key,
    required this.height,
    required this.collapsableHeight,
    required this.collapsableWidth,
    required this.isExpanded,
  });

  @override
  State<infoIndicator> createState() => _infoIndicatorState();
}

class _infoIndicatorState extends State<infoIndicator> {
  @override
  Widget build(BuildContext context) {
    //right line info
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      height: widget.height,
      //decoration: BoxDecoration(color: const Color.fromARGB(255, 93, 93, 93)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            //heading
            "Bhikaji Cama Place", //-------------------HERE--------------------------------------------
            style: TextStyle(
              color: const Color.fromARGB(255, 187, 187, 187),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
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
                  " Heading towards Majlis Park",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Blue Line",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Every 2 min",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          //SizedBox(height: 10),
          Spacer(),
          (widget.isExpanded == true)
              ? collapsedExpandedView() //add the collapsed station expanded display logo
              : Row(
                children: [
                  Text(
                    "6 Stations",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(width: 5),
                  Icon(CupertinoIcons.sort_down, color: Colors.grey, size: 20),
                ],
              ),
          Spacer(), //SPACERRRR
          Text(
            //heading
            "Rajori Garden",
            style: TextStyle(
              color: const Color.fromARGB(255, 187, 187, 187),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ); ////
  }
}

collapsedExpandedView() {
  //learn how itsss DONEE
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
        minimetroStations.entries.map((entry) {
          final station = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right_rounded, color: Colors.grey, size: 15),
                SizedBox(width: 2),
                Text(
                  station["name"],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }).toList(),
  );
}

interchangeInfo() {
  return Container(
    height: 70,
    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
    width: double.infinity,
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 54, 54, 54)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 7,
          height: 100,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                SizedBox(height: 2),
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.directions_walk, color: Colors.grey, size: 15),
                      Text(
                        "5 Min",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
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

reportError() {
  return Row(
    children: [
      Container(
        height: 50,
        width: 170,
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
                fontSize: 18, //processedFontheight(context),
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
    height: 50,
    //color: const Color.fromARGB(255, 57, 57, 57),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "DELHI\nUNDERGROUND",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1,
            color: const Color.fromARGB(255, 90, 90, 90),
            fontWeight: FontWeight.w700,
            fontSize: 14,
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
