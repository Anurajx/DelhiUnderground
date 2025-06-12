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
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          topNavBar(context),
          tripSummary(),
          Divider(thickness: 1, color: const Color.fromARGB(255, 35, 35, 35)),
          routeCluster(),
          routeCluster(),
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
      padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
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
              text: "50 Minutes ", //make these a variable
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
              text: "Rs 50. ",
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

routeCluster() {
  double height =
      250; //presetting height at one place so that text and line indicator stay at same height
  return Container(
    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        lineIndicator(height), //bar line indicator on left
        Expanded(
          child: infoIndicator(height),
        ), //station info and other info on right
      ],
    ),
  );
}

lineIndicator(height) {
  return Container(
    width: 7,
    height: height,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 47, 130, 255),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}

infoIndicator(height) {
  return Container(
    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
    height: height,
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 93, 93, 93)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          //heading
          "Bhikaji Cama Place",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Heaing towards Majlis Park",
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
        SizedBox(height: 2),
        Text(
          "Slightly Crowded",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(102, 54, 54, 54),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 150,
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "30 Stations",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Spacer(),
              Icon(CupertinoIcons.sort_down, color: Colors.grey),
            ],
          ),
        ),
        Spacer(), //SPACERRRR
        Text(
          //heading
          "Rajori Garden",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
