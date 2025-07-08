import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StationNameAndArrow(name),
          commonName(hindiName),
          SizedBox(
            height: 5,
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
            padding: const EdgeInsets.only(right: 5.0),
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
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: getColorFromLineNumber(line),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            "$line",
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
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
            color: const Color.fromARGB(255, 0, 122, 204),
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
            color: const Color.fromARGB(255, 200, 155, 0),
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
    );
  }
}

class stationNearby extends StatelessWidget {
  //for station list on main screen
  final dynamic name;

  const stationNearby({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            color: const Color.fromARGB(255, 0, 122, 204),
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
            color: const Color.fromARGB(255, 219, 112, 147),
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
        // Icon(
        //   CupertinoIcons.info_circle,
        //   color: const Color.fromARGB(255, 179, 179, 179),
        // ),
        Container(
          height: 20,
          width: 50,
          color: const Color.fromARGB(255, 199, 199, 199),
          child: Center(
            child: Text(
              "1 KM",
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
