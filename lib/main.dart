// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'elements/bus.dart';
import 'elements/metro.dart';
import 'elements/rrts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Geolocator.requestPermission();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
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
  int pageIndex = 0;
  final pages = [const Page1(), const Page2(), const Page3()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color:
                    pageIndex == 0
                        ? const Color.fromARGB(40, 255, 255, 255)
                        : Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
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
                    Image.asset('assets/metro.png', width: 20, height: 20),
                    SizedBox(height: 5),
                    const Text(
                      "METRO",
                      style: TextStyle(color: Colors.white, fontSize: 8),
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
                    Image.asset('assets/dtc.png', width: 24, height: 24),
                    const Text(
                      "BUS",
                      style: TextStyle(color: Colors.white, fontSize: 8),
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
                    pageIndex == 2
                        ? const Color.fromARGB(40, 255, 255, 255)
                        : Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  setState(() {
                    pageIndex = 2;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/ncrtc.png', width: 24, height: 24),
                    const Text(
                      "RRTS",
                      style: TextStyle(color: Colors.white, fontSize: 8),
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
