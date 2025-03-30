import 'package:flutter/material.dart';
import 'map.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'METRO',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: MapScreen(),
      ),
    );
  }
}
