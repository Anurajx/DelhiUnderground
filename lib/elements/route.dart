import 'dart:ffi';
import 'package:neopop/neopop.dart';

import 'metroStationsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Station_element.dart';

class routeScreen extends StatefulWidget {
  const routeScreen({super.key});

  @override
  State<routeScreen> createState() => _routeScreenState();
}

class _routeScreenState extends State<routeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            child: Text(
              "ROUTE SCREEN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
