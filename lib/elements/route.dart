import 'dart:ffi';
import 'package:neopop/neopop.dart';

import './ServicesDir/Station_element.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ServicesDir/Station_element.dart';

class routeScreen extends StatefulWidget {
  const routeScreen({super.key});

  @override
  State<routeScreen> createState() => _routeScreenState();
}

class _routeScreenState extends State<routeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.black, body: RouteDisplay()),
    );
  }
}

class RouteDisplay extends StatelessWidget {
  const RouteDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          topNavBar(context),
          tripSummary(),
          Divider(thickness: 1, color: const Color.fromARGB(255, 35, 35, 35)),
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
      ],
    ),
  );
}

class tripSummary extends StatelessWidget {
  const tripSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Your trip takes ",
              style: TextStyle(
                color: const Color.fromARGB(255, 110, 110, 110),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "50 Mins ", //make these a variable
              style: TextStyle(
                color: const Color.fromARGB(255, 230, 81, 0),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "has ",
              style: TextStyle(
                color: const Color.fromARGB(255, 110, 110, 110),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "2 interchange ",
              style: TextStyle(
                color: const Color.fromARGB(255, 230, 81, 0),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "and costs ",
              style: TextStyle(
                color: const Color.fromARGB(255, 110, 110, 110),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "Rs 50 ",
              style: TextStyle(
                color: const Color.fromARGB(255, 230, 81, 0),
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


// Text(
//         "Your trip takes 50 Mins has 2 interchanges and costs Rs 50",
//         style: TextStyle(
//           color: const Color.fromARGB(255, 109, 109, 109),
//           fontSize: 20,
//           fontWeight: FontWeight.w500,
//         ),
//       ),