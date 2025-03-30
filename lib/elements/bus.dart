import 'package:flutter/material.dart';
import 'map.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
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
            'BUS',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        body: MapScreen(),
      ),
    );
  }
}
