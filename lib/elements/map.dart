import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  String _mapStyle = "";
  LatLng? _center;
  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  _loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    setState(() {
      _mapStyle = style;
    });
    // Apply style when the map is ready
  }

  _loadUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    if (mounted) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _animateCameraToUserLocation() {
    if (_center != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _center!, zoom: 15.0),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    await _loadUserLocation();
    mapController = controller;
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
