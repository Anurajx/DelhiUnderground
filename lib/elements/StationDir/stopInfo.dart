import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stopInfoScreen extends StatefulWidget {
  const stopInfoScreen({super.key});

  @override
  State<stopInfoScreen> createState() => _stopInfoScreenState();
}

class _stopInfoScreenState extends State<stopInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "STOP INFO SCREEN",
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
