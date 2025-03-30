import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  }); //added superkey used to create state of MapScreen

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  String _mapStyle = ""; //initilizing all the variables
  LatLng? _center;
  bool _isLocationLoaded = false;

  @override //setting up the state for style at super level
  void initState() {
    super.initState();
    loadMapStyle().then((style) {
      setState(() {
        _mapStyle = style;
      });
      _loadUserLocation().then((_) {
        //changing the boolean value for when location is loaded
        setState(() {
          _isLocationLoaded = true;
        });
      });
    });
  }

  loadMapStyle() async {
    //laoding the style file path
    String style = await rootBundle.loadString('assets/map_style.json');
    return style;
  }

  Future<LatLng?> _loadUserLocation() async {
    //getting user location through geolocator
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    _center = LatLng(position.latitude, position.longitude);
    return _center;
  }

  void _onMapCreated(GoogleMapController controller) async {
    //function to intialize mapcontroller when maps is loaded
    mapController = controller;

    //_animateCameraToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocationLoaded) {
      //checking if lacation is loaded through boolean value
      return Center(
        child: CircularProgressIndicator(),
      ); //returing a loading widget
    }
    return MaterialApp(
      //returning map centered onuser laoction when loaded
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: GoogleMap(
          style: _mapStyle,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _center?.latitude ??
                  28.61295859148258, //checks if location is loaded if not then loads at default location
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
