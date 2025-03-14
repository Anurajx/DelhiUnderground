import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Center(
        child: Text(
          "Metro Page",
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
            fontSize: 45,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
