import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metroapp/elements/StationDir/stationSearch.dart';
//import 'package:lottie/lottie.dart';

class stopInfoScreen extends StatelessWidget {
  final dynamic stationDict;
  const stopInfoScreen({super.key, required this.stationDict});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
  return Container(
    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: Column(
      children: [
        topNavBar(context),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              stationLineMarker(stationDict),
              //SizedBox(height: 100),
              closeAndOpeningTime(),
              stationStatus(),
              SizedBox(height: 2),
              //toAndFromBlock(),
              SizedBox(height: 40),
              exitBlock(),
              SizedBox(height: 40),
              //exitBlock(),
              scheduleBlock(),
              SizedBox(height: 40),
              ammenitiesBlock(),
              SizedBox(height: 40),
              reportError(),
              SizedBox(height: 40),
              companyFooter(),
            ],
          ),
        ),
      ],
    ),
  );
}

topNavBar(context) {
  return Container(
    //color: const Color.fromARGB(0, 8, 8, 8),
    height: 50,
    //padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
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
                  fontSize: 18,
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
  String stationName = station[2].toString();
  String stationNameHindiCommon = station[1].toString();
  return Container(
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 164, 164, 164)),
    //margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
    height: 230,
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
            color: const Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$stationNameHindiCommon",
          style: TextStyle(
            color: const Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        SizedBox(height: 30),
      ],
    ),
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
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        //Spacer(),
      ],
    ),
  );
}

stationStatus() {
  return Container(
    height: 70,
    width: double.infinity,

    //color: Colors.teal,
    child: Row(
      children: [
        Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          width: 90,
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
                  fontSize: 15,
                ),
              ),
              Text(
                "crowd",
                style: TextStyle(
                  color: const Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2),
        Expanded(
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
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward, color: Colors.green, size: 20),
                  ],
                ),
                Text(
                  "check details",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
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

toAndFromBlock() {
  return Container(
    height: 70,
    width: double.infinity,
    //color: Colors.teal,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 207, 207, 207),
            width: 90,
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
                        fontSize: 15,
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
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 2),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 207, 207, 207),
            width: 90,
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
                        fontSize: 15,
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
                    fontSize: 15,
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
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Container(width: 80),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: const Color.fromARGB(255, 25, 25, 25),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Palika Bhawan, RK Puram Sector-13, New Delhi",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 172, 172, 172),
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
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        ////////////////////////////////////////
        SizedBox(height: 2),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Container(width: 80),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: const Color.fromARGB(255, 25, 25, 25),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "DTC Sarojini Nagar Depot",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 172, 172, 172),
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
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        SizedBox(height: 2),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                children: [
                  Container(width: 80),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: const Color.fromARGB(255, 25, 25, 25),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "EIL,Hyatt Regency, Gail India Ltd",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 172, 172, 172),
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
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              //color: Colors.blueAccent,
            ),
          ],
        ),
        SizedBox(height: 2),
        Container(
          //image with visualize of map blocl
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 80,
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
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: const Color.fromARGB(255, 25, 25, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Majlis Park",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 207, 207, 207),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 100,
                    height: 60,
                    color: const Color.fromARGB(255, 207, 207, 207),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Every",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 73, 73, 73),
                          ),
                        ),
                        Text(
                          "15 min",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 10, width: 10, color: Colors.blue),
          ],
        ),
        /////////
        SizedBox(height: 2),
        Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: const Color.fromARGB(255, 25, 25, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Mauj Pur",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 207, 207, 207),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 100,
                    height: 60,
                    color: const Color.fromARGB(255, 207, 207, 207),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Every",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 73, 73, 73),
                          ),
                        ),
                        Text(
                          "15 min",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 10, width: 10, color: Colors.blue),
          ],
        ),
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
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 80,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 207, 207, 207),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "available",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 14, 14, 14),
                                fontSize: 14,
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
                                fontSize: 14,
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
                height: 80,
                width: 130,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 80,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 207, 207, 207),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "unavailable",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 14, 14, 14),
                                fontSize: 14,
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
                                fontSize: 14,
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
                height: 80,
                width: 130,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 50,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              //SizedBox(width: 10),
              Text(
                "elevator",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                ">",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                "available",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
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
        SizedBox(height: 2),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 50,
          color: const Color.fromARGB(255, 25, 25, 25),
          child: Row(
            children: [
              //SizedBox(width: 10),
              Text(
                "washroom",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                ">",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                "available",
                style: TextStyle(
                  color: const Color.fromARGB(255, 182, 182, 182),
                  fontSize: 14,
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
