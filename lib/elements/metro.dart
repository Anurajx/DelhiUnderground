import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late GoogleMapController mapController;
  String _mapStyle = "";

  final LatLng _center = const LatLng(28.563183776641193, 77.18832912180038);

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    setState(() {
      _mapStyle = style;
    });

    // Apply style when the map is ready
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller; // Apply the style here
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: Scaffold(
        body: GoogleMap(
          style: _mapStyle,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
          markers: {
            const Marker(
              markerId: MarkerId("1"),
              position: LatLng(28.563183776641193, 77.18832912180038),
            ),
          },
        ),
      ),
    );
  }
}
