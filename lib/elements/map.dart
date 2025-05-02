import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart' as csv;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  }); //added superkey used to create state of MapScreen

  @override
  State<MapScreen> createState() => _MapScreenState();
}

const LatLng _defaultLocation = LatLng(28.61295859148258, 77.22884208025665);

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  String? _mapStyle; //initilizing all the variables
  LatLng? _center;
  bool _isLocationLoaded = false;

  @override //setting up the state for style at super level
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapAssets();
      _isLocationLoaded = true;
    });
  }

  Future<void> _mapAssets() async {
    await _getLastLocation();
    _mapStyle = await loadMapStyle();
    _loadUserLocation(); //user loaction will be taken later as it is not await needed
  }

  Future<LatLng?> _loadUserLocation() async {
    //getting user location through geolocator
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );
    final prefs =
        await SharedPreferences.getInstance(); // saving the user location for cashe
    prefs.setDouble('lastlatitude', position.latitude);
    prefs.setDouble('lastlongitude', position.longitude);

    LatLng newcenter = LatLng(position.latitude, position.longitude);

    _isLocationLoaded = true;
    setState(() {
      _center = newcenter;
    });
    return _center;
  }

  Future<LatLng> _getLastLocation() async {
    //fucntion to get last saved location saves time at time of launch
    //get last saved location
    final prefs =
        await SharedPreferences.getInstance(); // reading user location from cashe
    double? lat = prefs.getDouble('lastlatitude');
    double? lon = prefs.getDouble('lastlongitude');
    _isLocationLoaded = true;
    if (lat == null || lon == null) {
      setState(() {
        _center = _defaultLocation;
      });
      return _defaultLocation;
    }
    LatLng oldcenter = LatLng(lat, lon);
    setState(() {
      _center = oldcenter;
    });
    return _center!;
  }

  void _onMapCreated(GoogleMapController controller) async {
    //function to intialize mapcontroller when maps is loaded
    mapController = controller;
    mapController!.animateCamera(CameraUpdate.newLatLng(_center!));
    //_animateCameraToUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    //   if (!_isLocationLoaded) {
    //     return Container(
    //       width: double.infinity,
    //       decoration: BoxDecoration(color: const Color.fromARGB(255, 26, 26, 26)),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Container(
    //             child: Image.asset(
    //               "assets/Image/internet.jpg",
    //               width: 180,
    //               height: 200,
    //             ),
    //           ),
    //         ],
    //       ),
    //       //child: Image.asset("assets/Image/internet.jpeg", width: 50, height: 50),
    //     ); //add logic here
    //   }
    return GoogleMap(
      // remove const if adding any varible
      style: _mapStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center ?? _defaultLocation,
        zoom: 14,
      ),
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      myLocationButtonEnabled: true,
      myLocationEnabled: false, //enablet o view that location blue dot
      zoomControlsEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(11, 18),
    );
  }
}

Future<String> loadMapStyle() async {
  //String style = await rootBundle.loadString('assets/Map/map_style.json');
  String style = """ [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
""";
  return style;
}
