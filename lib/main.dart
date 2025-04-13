// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'elements/bus.dart';
import 'elements/metro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Geolocator.requestPermission(); //requesting permission for location: to be shited to intro screen
    return MaterialApp(
      title: 'Transit Co',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: "Poppins", //poppins default font
            fontWeight: FontWeight.w300, //default font weight
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: MyHomePage(),
      ), //added safe area such that it is not cut by any notch or screen cutouts
      //
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0; //initizing page index
  final pages = [
    const Page1(),
    const Page2(),
  ]; //inilizing array of apges for navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: IndexedStack(index: pageIndex, children: pages),
      bottomNavigationBar: buildMyNavBar(context), //bottom navigation
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(color: Colors.black),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, //navigation bar alignment
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color:
                    pageIndex ==
                            0 //checks for index of current page
                        ? const Color.fromARGB(
                          40,
                          255,
                          255,
                          255,
                        ) //suggests current selected page
                        : Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                //creates inkwell for navigation, making an expanded area for tapping
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Image/metro.png',
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(height: 5),
                    const Text(
                      "METRO",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color:
                    pageIndex == 1
                        ? const Color.fromARGB(40, 255, 255, 255)
                        : Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/Image/dtc.png', width: 24, height: 24),
                    const Text(
                      "BUS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
