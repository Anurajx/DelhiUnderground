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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$name',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: const Color.fromARGB(255, 179, 179, 179),
              fontSize: 18,
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
                  color: Colors.white,
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
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Text(
                "7",
                style: TextStyle(
                  color: Colors.white,
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
                  color: const Color.fromARGB(0, 255, 255, 255),
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
