import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart' as csv;

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  }); //added superkey used to create state of MapScreen

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final LatLng _defultLocation = LatLng(28.61295859148258, 77.22884208025665);
  String? _mapStyle = ""; //initilizing all the variables
  LatLng? _center;
  bool _isLocationLoaded = false;

  @override //setting up the state for style at super level
  void initState() {
    super.initState();
    _mapAssets();
  }

  Future<void> _mapAssets() async {
    // consolidated all set states at one place
    try {
      final results = await Future.wait([_loadUserLocation(), loadMapStyle()]);

      final loadedLocation = results[0] as LatLng?;
      final loadedStyle = results[1] as String?;
      _isLocationLoaded = true;

      setState(() {
        _center = loadedLocation ?? _defultLocation;
        _mapStyle = loadedStyle;
      });
    } catch (e) {
      _isLocationLoaded = false;
    }
  }

  Future<LatLng?> _loadUserLocation() async {
    //getting user location through geolocator
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.low),
    );
    _center = LatLng(position.latitude, position.longitude);
    return _center;
  }

  void _onMapCreated(GoogleMapController controller) async {
    //function to intialize mapcontroller when maps is loaded
    mapController = controller;
    if (_mapStyle != null) {
      mapController!.setMapStyle(_mapStyle);
    }
    //_animateCameraToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocationLoaded) {
      //checking if lacation is loaded through boolean value
      return Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 0, 0)),
        child: Center(
          child: const Text(
            "Fetching Map",
            style: TextStyle(
              fontFamily: 'Doto',
              fontSize: 30,
              color: Color.fromARGB(255, 230, 81, 0),
            ),
          ),
        ),
      ); //returing a loading widget
    }
    return Scaffold(
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
    );
  }
}

Future<String> loadMapStyle() async {
  //loads data from files
  //laoding the style file path
  String style = await rootBundle.loadString('assets/Map/map_style.json');
  String Stations = await rootBundle.loadString(
    'assets/Map/mstops.txt',
  ); //loading stations data

  return style;
}
