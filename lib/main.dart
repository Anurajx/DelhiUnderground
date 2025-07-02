import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'elements/metro.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized(); // Required to set system styles before UI build

  SystemChrome.setSystemUIOverlayStyle(
    //telling app what should status bar should look like, later called inside the build
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Or black
      statusBarIconBrightness: Brightness.light, // dark icons for light bg
    ),
  );
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
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        //for making sure top status bar is always visible
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.black, // Background color of status bar
          statusBarIconBrightness: Brightness.light, // White icons for dark bg
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          body: SafeArea(child: Page1()),
        ),
      ), //added safe area such that it is not cut by any notch or screen cutouts      //
    );
  }
}
