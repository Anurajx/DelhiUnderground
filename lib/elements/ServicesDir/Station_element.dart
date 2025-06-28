import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Station extends StatelessWidget {
  final dynamic name;

  const Station({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //ADD APP LOGIC HERE FOR NEXT SCREEN
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StationNameAndArrow(name),
          commonName(name),
          SizedBox(
            height: 5,
          ), //added to even out the padding from top and bottom
          stationLineBadge(),
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

stationLineBadge() {
  return Row(
    children: [
      // SizedBox(
      //   width: 10,
      // ), // adding to create a bit of space between line indicatot and text
      Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
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
          color: Colors.red,
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
