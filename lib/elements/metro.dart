import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late GoogleMapController mapController;

  String _mapStyle = "";
  LatLng? _center;
  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  _loadMapStyle() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    print('MY_TAG1: Position: $position');
    String style = await rootBundle.loadString('assets/map_style.json');
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _mapStyle = style;
    });
    // Apply style when the map is ready
  }

  void _animateCameraToUserLocation() {
    print('MY_TAG: Position: $_center');
    if (_center != null) {
      print('MY_TAG3: Position: $_center');
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _center!, zoom: 15.0),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    await _loadMapStyle();
    mapController = controller;
    print('MY_TAG5: Position: $_center');
    _animateCameraToUserLocation(); // Apply the style here
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
          initialCameraPosition: CameraPosition(
            target: _center ?? LatLng(28.61302114428857, 77.22860971044535),
            zoom: 13.0,
          ),
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          minMaxZoomPreference: MinMaxZoomPreference(11, 18),
        ),
      ),
    );
  }
}
