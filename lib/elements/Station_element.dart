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
            width: 5,
          ), // adding to create a bit of space between line indicatot and text
          Container(
            width: 5,
            height: 15,
            color: const Color(
              0xFF0072BC,
            ), //blue line color will make it dynamic later
          ),
          Container(
            width: 5,
            height: 15,
            color: const Color(
              0xFFF47B20,
            ), //blue line color will make it dynamic later
          ),
          Container(
            width: 5,
            height: 15,
            color: const Color.fromARGB(
              255,
              255,
              65,
              65,
            ), //blue line color will make it dynamic later
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
