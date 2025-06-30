import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stationUnit extends StatelessWidget {
  final dynamic name;
  final dynamic zone;
  final List lines;

  const stationUnit({
    super.key,
    required this.name,
    required this.zone,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StationNameAndArrow(name),
        commonName(zone),
        SizedBox(height: 5), //added to even out the padding from top and bottom
        stationLineBadge(lines),
      ],
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
          fontSize: 12,
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
          fontSize: 18,
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
      return Colors.red;
    case 2:
      return Colors.blue;
    case 3:
      return Colors.green;
    case 4:
      return Colors.yellow;
    case 5:
      return Colors.purple;
    case 6:
      return const Color.fromARGB(255, 255, 215, 34);
    case 7:
      return const Color.fromARGB(255, 220, 24, 255);
    case 8:
      return const Color.fromARGB(255, 67, 34, 255);
    case 9:
      return const Color.fromARGB(255, 36, 208, 255);
    case 15:
      return const Color.fromARGB(255, 255, 137, 3);
    default:
      return const Color.fromARGB(228, 255, 255, 255);
  }
} //build this line indicator builder tommorow

stationLineBadge(lines) {
  int lineNumber = lines[0];
  return Row(
    children: [
      // SizedBox(
      //   width: 10,
      // ), // adding to create a bit of space between line indicatot and text
      Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: getColorFromLineNumber(lineNumber),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "3",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      SizedBox(width: 5),
      Container(
        width: 17,
        height: 17,

        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 244, 67, 54),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "7",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ), //make this change dynamically based on the station
      ),

      SizedBox(width: 5),
      Container(
        width: 17,
        height: 17,

        decoration: BoxDecoration(
          color: const Color.fromARGB(0, 255, 235, 59),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "1",
            style: TextStyle(
              color: const Color.fromARGB(0, 255, 255, 255),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    ],
  );
}

class stationPrimitive extends StatelessWidget {
  //for station list on main screen
  final dynamic name;

  const stationPrimitive({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //ADD APP LOGIC HERE FOR NEXT SCREEN
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 179, 179, 179),
              fontSize: 18,
              fontWeight: FontWeight.w300, //300
            ),
          ),
          SizedBox(
            width: 10,
          ), // adding to create a bit of space between line indicatot and text
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "3",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // color: const Color(
            //   0xFF0072BC,
            // ), //blue line color will make it dynamic later
          ),
          SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,

            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "7",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ), //make this change dynamically based on the station
            // color: const Color(
            //   0xFFF47B20,
            // ), //blue line color will make it dynamic later
          ),

          SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,

            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 235, 59),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "1",
                style: TextStyle(
                  color: const Color.fromARGB(0, 0, 0, 0),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // color: const Color.fromARGB(
            //   255,
            //   249,
            //   134,
            //   255,
            // ), //blue line color will make it dynamic later
          ),
          Spacer(),
          Icon(
            CupertinoIcons.arrow_right,
            color: const Color.fromARGB(255, 179, 179, 179),
          ),
        ],
      ),
    );
  }
}

class stationNearby extends StatelessWidget {
  //for station list on main screen
  final dynamic name;

  const stationNearby({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //ADD APP LOGIC HERE FOR NEXT SCREEN
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 179, 179, 179),
              fontSize: 18, //18
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            width: 10,
          ), // adding to create a bit of space between line indicatot and text
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "3",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // color: const Color(
            //   0xFF0072BC,
            // ), //blue line color will make it dynamic later
          ),
          SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,

            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "7",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ), //make this change dynamically based on the station
            // color: const Color(
            //   0xFFF47B20,
            // ), //blue line color will make it dynamic later
          ),

          SizedBox(width: 5),
          Container(
            width: 15,
            height: 15,

            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 235, 59),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "1",
                style: TextStyle(
                  color: const Color.fromARGB(0, 0, 0, 0),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            // color: const Color.fromARGB(
            //   255,
            //   249,
            //   134,
            //   255,
            // ), //blue line color will make it dynamic later
          ),
          Spacer(),
          Icon(
            CupertinoIcons.info_circle,
            color: const Color.fromARGB(255, 179, 179, 179),
          ),
        ],
      ),
    );
  }
}
