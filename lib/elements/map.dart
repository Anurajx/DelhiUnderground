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
  bool _isLocationLoaded = false;

  @override
  void initState() {
    super.initState();
    loadMapStyle().then((style) {
      setState(() {
        _mapStyle = style;
      });
      _loadUserLocation().then((_) {
        setState(() {
          _isLocationLoaded = true;
        });
      });
    });
  }

  loadMapStyle() async {
    String style = await rootBundle.loadString('assets/map_style.json');
    return style;
    // Apply style when the map is ready
  }

  Future<LatLng?> _loadUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    _center = LatLng(position.latitude, position.longitude);
    return _center;
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    //_animateCameraToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocationLoaded) {
      return Center(child: CircularProgressIndicator());
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: GoogleMap(
          style: _mapStyle,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _center?.latitude ?? 28.61295859148258,
              _center?.longitude ?? 77.22884208025665,
            ),
            zoom: 15,
          ),
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          minMaxZoomPreference: MinMaxZoomPreference(11, 18),
        ),
      ),
    );
  }
}
