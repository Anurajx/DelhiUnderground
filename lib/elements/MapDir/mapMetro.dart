import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mapMetroScreen extends StatefulWidget {
  const mapMetroScreen({super.key});

  @override
  State<mapMetroScreen> createState() => _mapMetroScreenState();
}

class _mapMetroScreenState extends State<mapMetroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "METRO MAP SCREEN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
