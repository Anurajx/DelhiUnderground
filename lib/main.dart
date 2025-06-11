import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'elements/metro.dart';

void main() {
  //making sure splash screen persisits
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Future<void> _permissions() async {}

  @override
  Widget build(BuildContext context) {
    //Geolocator.requestPermission(); //requesting permission for location: to be shited to intro screen
    return MaterialApp(
      title: 'Metro App',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            fontFamily: "Poppins", //poppins default font
            fontWeight: FontWeight.w300, //default font weight
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color.fromARGB(255, 47, 130, 255),
          selectionColor: const Color.fromARGB(150, 47, 130, 255),
          selectionHandleColor: const Color.fromARGB(255, 47, 130, 255),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Page1(),
      ), //added safe area such that it is not cut by any notch or screen cutouts
      //
    );
  }
}
