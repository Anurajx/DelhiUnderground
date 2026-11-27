import 'dart:convert';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/main.dart';
import 'package:metroapp/elements/StationDir/stop_info.dart';
import 'route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ServicesDir/station_element.dart';

class SearchScreen extends StatefulWidget {
  final String? destination;
  const SearchScreen({
    super.key,
    this.destination,
  }); //if destination comes as an argument aslo calulate sopurce station with gps location if gps not available use homestation if that too now available leave that space empty

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SearchBody(context: context, destination: widget.destination),
        //resizeToAvoidBottomInset: true,
      ),
    );
  }
}

class SearchBody extends StatefulWidget {
  final dynamic context;
  final String? destination;

  const SearchBody({super.key, required this.context, this.destination});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  List<dynamic> orignalStations = [];
  List<dynamic> filteredStations = [];
  Map<int, Color> _lineColorsById = {};
  //bool _shouldClear = false;

  @override
  void initState() {
    super.initState();
    _controller1.text =
        coreTransferStationsDict['Source']?['Name']?.toString() ?? '';
    _controller2.text =
        coreTransferStationsDict['Destination']?['Name']?.toString() ?? '';
    _focusNode1.addListener(() {
      setState(() {
        filterStationsLogic(_controller1.text);
      });
    });
    _focusNode2.addListener(() {
      setState(() {
        filterStationsLogic(_controller2.text);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode1.requestFocus();
    });
    _loadStations();
  }

  void _searchRoutes() {
    final sourceName = _controller1.text.trim();
    final destinationName = _controller2.text.trim();
    final savedSource = coreTransferStationsDict['Source'];
    final savedDestination = coreTransferStationsDict['Destination'];
    final source =
        savedSource is Map && savedSource['Name'] == sourceName
            ? Map<String, dynamic>.from(savedSource)
            : _findStationSelection(sourceName);
    final destination =
        savedDestination is Map && savedDestination['Name'] == destinationName
            ? Map<String, dynamic>.from(savedDestination)
            : _findStationSelection(destinationName);

    if (sourceName.isEmpty ||
        destinationName.isEmpty ||
        source == null ||
        destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 31, 200, 127),
          content: Text(
            'Please select both departure and arrival correctly',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
      return;
    }

    coreTransferStationsDict['Source'] = source;
    coreTransferStationsDict['Destination'] = destination;
    screenTransferController(context, _controller1, _controller2);
  }

  Map<String, dynamic>? _findStationSelection(String name) {
    for (final station in orignalStations) {
      if (station['station_name'] == name) {
        return _stationSelectionFromRow(station);
      }
    }
    return null;
  }

  Future<void> _loadStations() async {
    try {
      final db = await MetroDbService.getDatabase();
      final stations = await db.query('metro_stations');
      final lineRows = await db.query(
        'metro_lines',
        columns: ['id', 'primary_color_code'],
      );
      final lineColorsById = <int, Color>{};
      for (final line in lineRows) {
        final lineId = line['id'] as int;
        final colorCode = line['primary_color_code'] as String;
        lineColorsById[lineId] = Color(
          int.parse(colorCode.substring(1), radix: 16) | 0xFF000000,
        );
      }

      if (!mounted) return;
      setState(() {
        orignalStations = stations;
        filteredStations = stations;
        _lineColorsById = lineColorsById;
      });
    } catch (error, stackTrace) {
      debugPrint('Error loading stations from metro.db: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _controller1.dispose();
    _controller2.dispose();
    coreTransferStationsDict['Source'] = {};
    coreTransferStationsDict['Destination'] = {};
    super.dispose();
  }

  void filterStationsLogic(String query) {
    final normalizedQuery = _normalizeStationSearchText(query);

    setState(() {
      if (normalizedQuery.isNotEmpty) {
        final scoredList =
            orignalStations
                .where((station) => station["station_name"] != null)
                .map((station) {
                  final name = _normalizeStationSearchText(
                    station["station_name"].toString(),
                  );
                  final hindiName = _normalizeStationSearchText(
                    station["station_name_hindi"]?.toString() ?? "",
                  );
                  final nameScore = _stationSearchScore(name, normalizedQuery);
                  final hindiScore = _stationSearchScore(
                    hindiName,
                    normalizedQuery,
                  );

                  return MapEntry(
                    station,
                    nameScore > hindiScore ? nameScore : hindiScore,
                  );
                })
                .where((entry) => entry.value >= 0.65)
                .toList();

        scoredList.sort((a, b) => b.value.compareTo(a.value));

        filteredStations = scoredList.map((entry) => entry.key).toList();
      } else {
        filteredStations = orignalStations;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      //decoration: BoxDecoration(color: const Color.fromARGB(255, 8, 8, 8)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          backBox(
            context,
            _controller1,
            _controller2,
            onSearch: () {
              FocusScope.of(context).unfocus();
              _searchRoutes();
            },
          ),
          screenName(), //leave as is
          Stack(
            //adding the search cluster here
            alignment: Alignment.centerLeft,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10, //left: 40,
                      top: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 208, 208, 208),
                      //color: const Color.fromARGB(255, 8, 8, 8),
                      // border: Border.all(
                      //   color: const Color.fromARGB(255, 234, 234, 234),
                      //   width: 1,
                      // ),
                      borderRadius: BorderRadius.circular(0), //40
                    ),
                    //width: double.infinity,
                    height: 90.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: TextField(
                            textCapitalization:
                                TextCapitalization
                                    .sentences, //makes the keyboard open with caps on for first letter
                            focusNode: _focusNode1,
                            cursorOpacityAnimates: true,
                            controller: _controller1,
                            onChanged: filterStationsLogic,
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "From",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(200, 68, 68, 68),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextStyle(
                              color: const Color.fromARGB(225, 15, 15, 15),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 8, 8, 8),
                          height: 1.h,
                          thickness: 2,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _focusNode2,
                            cursorOpacityAnimates: true,
                            controller: _controller2,
                            onChanged: filterStationsLogic,
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "To",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(200, 68, 68, 68),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextStyle(
                              color: const Color.fromARGB(225, 15, 15, 15),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.divider,
                    thickness: 0.2,
                    height: 1.h,
                  ),
                ],
              ),
              //fromToIcon(),
            ], //add flip circle function flipcircle()
          ),
          stationList(
            filteredStations,
            _controller1,
            _controller2,
            _focusNode1,
            _focusNode2,
            _lineColorsById,
            () => setState(() {}),
          ),
        ],
      ),
    );
  }
}

final RegExp _stationSearchSeparators = RegExp(
  r'[^\p{L}\p{M}\p{N}]',
  unicode: true,
);

String _normalizeStationSearchText(String value) =>
    value.toLowerCase().replaceAll(_stationSearchSeparators, '');

double _stationSearchScore(String station, String query) {
  if (station.isEmpty || query.isEmpty) return 0;
  if (station.contains(query)) {
    return station.startsWith(query) ? 1 : 0.9;
  }

  final stationCharacters = station.runes.toList();
  final queryCharacters = query.runes.toList();
  var previousRow = List<int>.generate(
    queryCharacters.length + 1,
    (index) => index,
  );

  for (
    var stationIndex = 1;
    stationIndex <= stationCharacters.length;
    stationIndex++
  ) {
    final currentRow = List<int>.filled(queryCharacters.length + 1, 0)
      ..[0] = stationIndex;
    for (
      var queryIndex = 1;
      queryIndex <= queryCharacters.length;
      queryIndex++
    ) {
      final substitutionCost =
          stationCharacters[stationIndex - 1] == queryCharacters[queryIndex - 1]
              ? 0
              : 1;
      final insertion = currentRow[queryIndex - 1] + 1;
      final deletion = previousRow[queryIndex] + 1;
      final substitution = previousRow[queryIndex - 1] + substitutionCost;
      currentRow[queryIndex] = [
        insertion,
        deletion,
        substitution,
      ].reduce((first, second) => first < second ? first : second);
    }
    previousRow = currentRow;
  }

  final longestLength =
      stationCharacters.length > queryCharacters.length
          ? stationCharacters.length
          : queryCharacters.length;
  return 1 - previousRow.last / longestLength;
}

Widget backBox(
  BuildContext context,
  controller1,
  controller2, {
  required VoidCallback onSearch,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        //back button sized box
        padding: EdgeInsets.fromLTRB(0, 20, 15, 20),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (MediaQuery.of(context).viewInsets.bottom != 0) {
              //if keyboard is open it closes first then the screen goes back
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.back,
                color: const Color.fromARGB(255, 47, 130, 255),
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: const Color.fromARGB(255, 47, 130, 255),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 0, 20),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSearch,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Search",
                style: TextStyle(
                  color: const Color.fromARGB(255, 47, 130, 255),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18.sp,
                ),
              ),
              Icon(
                CupertinoIcons.forward,
                color: const Color.fromARGB(255, 47, 130, 255),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

screenName() {
  //Plan your trip box
  return Center(
    child: Text(
      "Plan your trip",
      style: TextStyle(
        color: Color.fromARGB(255, 220, 220, 220),
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget fromToIcon() {
  //icons on the left side of the search box
  return Column(
    children: [
      Icon(CupertinoIcons.circle, color: Colors.white),
      Icon(Icons.arrow_drop_down, color: Colors.white),
      Icon(CupertinoIcons.square, color: Colors.white),
    ],
  );
}

Map<String, dynamic> coreTransferStationsDict = {
  //used for transfer screen process, making sure both source and destination are available
  //Dictionary format
  'Source': {}, //adding some defaults
  'Destination': {},
  'RouteType': 'least-distance',
};

Map<String, dynamic> _stationSelectionFromRow(dynamic station) {
  final name = station['station_name'] as String;
  return Map<String, dynamic>.from(station as Map)
    ..['Name'] = name
    ..['Hindi'] = station['station_name_hindi']
    ..['StationCode'] = station['station_code'];
}

Widget stationList(
  // widget that is expanded and scrollable of stations at bottom
  List<dynamic> stations,
  controller1,
  controller2,
  focusNode1,
  focusNode2,
  Map<int, Color> lineColorsById,
  VoidCallback onSelectionChanged,
) {
  if (stations.isEmpty) {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 30),
          //CupertinoActivityIndicator(color: Colors.white, radius: 15),
          Icon(
            CupertinoIcons.exclamationmark_circle_fill,
            color: Color.fromARGB(255, 255, 145, 145),
          ),
          Text(
            "no matches found",
            style: TextStyle(
              color: Color.fromARGB(255, 255, 145, 145),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  return Expanded(
    child: ListView.separated(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        var station = stations[index];

        // Defensive check
        if (station.length < 3) {
          return const SizedBox(); // or some error placeholder
        }
        final lineData =
            jsonDecode(station['metro_lines']?.toString() ?? '[]')
                as List<dynamic>;
        final lineNumbers =
            lineData.map<int>((line) => line['id'] as int).toList();
        final name = station['station_name'] as String;
        final hindiName = station['station_name_hindi'];
        final stationSelection = _stationSelectionFromRow(station);

        return InkWell(
          focusColor: const Color.fromARGB(0, 255, 255, 255),
          splashColor: const Color.fromARGB(86, 76, 76, 76),
          onTap: () {
            //print("ControllerName: $name");
            if (focusNode1.hasFocus) {
              print("coreTransferStationsDict is focus node 2 fault");
              //inputs text in the text filed on tap
              controller1.text = name;
              //FocusScope.of(context).requestFocus(focusNode2);
              coreTransferStationsDict['Source'] = stationSelection;
              onSelectionChanged();
              if (ifDestinationSelected()) {
                screenTransferController(context, controller1, controller2);
              } else {
                focusNode2.requestFocus();
              }
            }
            if (focusNode2.hasFocus) {
              print("coreTransferStationsDict is focus node 2 fault");
              controller2.text = name;
              coreTransferStationsDict['Destination'] = stationSelection;
              onSelectionChanged();

              // screenTransferController(
              //   context,
              //   controller1.text,
              //   controller2.text,
              // );
              if (ifSourceSelected()) {
                screenTransferController(context, controller1, controller2);
              } else {
                focusNode1.requestFocus();
              }
            }
            //  else {
            //   focusNode1.requestFocus();
            //   controller1.text = name;
            //   FocusScope.of(context).requestFocus(focusNode2);
            // }
          },
          child: StationUnit(
            name: name,
            hindiName: hindiName,
            lines: lineNumbers,
            lineColorsById: lineColorsById,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Color.fromARGB(255, 27, 27, 27), height: 1);
      },
    ),
  );
}

screenTransferController(context, controller1, controller2) {
  String source = controller1.text;
  String destination = controller2.text;
  //sends user to next route screen
  if (
  // ifSourceSelected() &&
  //   ifDestinationSelected() &&
  source.isNotEmpty &&
      destination.isNotEmpty &&
      coreTransferStationsDict['Source'] !=
          coreTransferStationsDict['Destination']) {
    //checks for source and destination in dectinory and the text controller text if all are valid only then proceed and destination is not same as source
    if (coreTransferStationsDict['Source']!["Name"] != source ||
        coreTransferStationsDict['Destination']!["Name"] != destination) {
      //confirms user input if there is a mismatch between dictionary and textfield
      showDialog(
        //warns user with that BIG GREEN BOX for mis match
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 31, 200, 127),
              title: Text(
                "${coreTransferStationsDict['Source']!['Name']} to ${coreTransferStationsDict['Destination']!['Name']}",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFamily: "Poppins",
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              content: Text(
                'Is this correct?',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    coreTransferStationsDict
                        .clear(); //reset just so user does not gets even more confused
                    controller1.text = ''; //reset
                    controller2.text = ''; //reset
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder:
                            (context) => RouteScreen(
                              coreTransferStationsDict:
                                  coreTransferStationsDict,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ),
              ],
            ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RouteScreen(
                coreTransferStationsDict: coreTransferStationsDict,
              ),
        ),
      );
    }
  } else {
    final snackBar = SnackBar(
      backgroundColor: const Color.fromARGB(255, 31, 200, 127),
      content: const Text(
        'Please select both departure and arrival correctly',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w300,
          fontFamily: "Poppins",
        ),
      ),
      action: SnackBarAction(
        backgroundColor: Colors.black,
        label: 'Okay',
        textColor: Colors.white,
        onPressed: () {
          //if you think of anyhting that would be good for UX add here
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

bool ifSourceSelected() {
  //put these checks on different and opposite text fields
  try {
    return coreTransferStationsDict['Source']?.isNotEmpty ?? false;
  } catch (e) {
    return false;
  }
}

bool ifDestinationSelected() {
  try {
    return coreTransferStationsDict['Destination']?.isNotEmpty ?? false;
  } catch (e) {
    return false;
  }
}
