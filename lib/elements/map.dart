import 'dart:io';
import 'SER_Lines_Stations_Styles.dart';
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
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override //setting up the state for style at super level
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapAssets();
    });
  }

  Future<void> _mapAssets() async {
    await _getLastLocation();
    await _fetchMapDatas();
    _mapStyle = await loadMapStyle();
    _loadUserLocation(); //user loaction will be taken later as it is not await needed
  }

  Future<void> _fetchMapDatas() async {
    final mapData = await loadMapData();
    final polylines = await loadMetroPolylinesFromGTFS();
    final markers =
        mapData.stops.asMap().entries.map((entry) {
          //print("Stops ${entry.value}");
          //print("Stops Index ${entry.key}");
          final index = entry.key;
          final stop = entry.value;
          return Marker(
            markerId: MarkerId(index.toString()),
            position: stop,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          );
        }).toSet();

    setState(() {
      _markers = markers;
      _polylines = Set.from(polylines);
    });
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

    if (mapController != null) {
      //checks if map controller is available, if yes than animates the camera to location
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(newcenter, 14));
    }

    setState(() {
      _center = newcenter;
    });
    return _center;
  }

  Future<LatLng> _getLastLocation() async {
    //check if last location cashe service is working as intended
    //fucntion to get last saved location saves time at time of launch
    //get last saved location
    final prefs =
        await SharedPreferences.getInstance(); // reading user location from cashe
    double? lat = prefs.getDouble('lastlatitude');
    double? lon = prefs.getDouble('lastlongitude');
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

  // void _onMapCreated(GoogleMapController controller) async {
  //   //function to intialize mapcontroller when maps is loaded
  //   mapController = controller;
  // }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      // remove const if adding any varible
      style: _mapStyle,
      onMapCreated: (controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: _center ?? _defaultLocation,
        zoom: 12,
      ),
      tiltGesturesEnabled: false,
      rotateGesturesEnabled: false,
      myLocationButtonEnabled: true,
      myLocationEnabled: false, //enablet o view that location blue dot
      zoomControlsEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(11, 18),
      markers: _markers,
      polylines: _polylines,
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
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
