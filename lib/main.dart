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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Page1(),
      //bottomNavigationBar: buildMyNavBar(context), //bottom navigation
    );
  }
}
