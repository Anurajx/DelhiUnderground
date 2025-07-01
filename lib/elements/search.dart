import 'dart:ffi';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:neopop/neopop.dart';
import 'route.dart';
import './ServicesDir/metroStationsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ServicesDir/Station_element.dart';
import 'dart:isolate';
import 'package:string_similarity/string_similarity.dart';

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
        backgroundColor: const Color.fromARGB(255, 8, 8, 8),
        body: searchBody(context: context, destination: widget.destination),
        //resizeToAvoidBottomInset: true,
      ),
    );
  }
}

class searchBody extends StatefulWidget {
  final dynamic context;
  final String? destination;

  const searchBody({super.key, required this.context, this.destination});

  @override
  State<searchBody> createState() => _searchBodyState();
}

class _searchBodyState extends State<searchBody> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  List<dynamic> orignalStations = [];
  List<dynamic> filteredStations = [];

  @override
  void initState() {
    super.initState();
    if (widget.destination != null) {
      //if an argument available it gives it to second text filed controller
      _controller2.text = widget.destination!;
    }

    _focusNode2.addListener(() {
      //manual check
      if (_focusNode2.hasFocus || _focusNode1.hasFocus) {
        //sets the filtered list to default when the focus changes
        //print("Focus Node 2 has focus");
        setState(() {
          if (_focusNode2.hasFocus) {
            // resets the field check if the valid argumanet is given or not
            fieldvalidator2 = false;
            manualStationVerificationLogic();
          }
          if (_focusNode1.hasFocus) {
            fieldvalidator1 = false;
            manualStationVerificationLogic();
          }
          filteredStations =
              orignalStations; //important for filtered list reset
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode1.requestFocus();
    });
    loadStationsFromCSV().then((stations) {
      setState(() {
        //print("Stations is $Stations");
        orignalStations = stations;
        filteredStations = stations;
        print("filteredStations is $filteredStations");
        //print("filteredStations is $filteredStations");
      });
    });
  }

  manualStationVerificationLogic() {
    //when adding that list that stores data suppose an argumanet is alredy given and is comcing frm home screen than you will need to also indetify which staiotn that query that is laredy there is, it will be easy as mostly 99.9% times it will be exact match
    //and delay is fine as user if really wants to change some station he will take time
    //works with abit of delay but that should'nt be an issue as planned the inputed station in the first time will be stored inside a list that will be reatined that has full detail of from and to station, making sure that even if an invalid station is inputed the app will use the stored data
    //to hadnle situtation when user selctes the sation form hoemscreen from recent fields and when the user returns from route screen and we need to validate the stations
    bool isExactStationMatch(String query, List<dynamic> stationList) {
      return stationList.any(
        (station) =>
            station[2].toLowerCase().trim() == query.toLowerCase().trim(),
      );
    }

    if (isExactStationMatch(_controller1.text, orignalStations)) {
      setState(() {
        fieldvalidator1 = true;
      });
    }
    if (isExactStationMatch(_controller2.text, orignalStations)) {
      setState(() {
        fieldvalidator2 = true;
      });
    }
  }

  void filterStationsLogic(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      if (query.isNotEmpty) {
        // Create list of entries with scores
        final scoredList =
            orignalStations
                .where((station) => station.length >= 3)
                .map((station) {
                  final name = station[2]?.toString().toLowerCase() ?? "";
                  final zone = station[1]?.toString().toLowerCase() ?? "";

                  final nameScore = StringSimilarity.compareTwoStrings(
                    name,
                    lowerQuery,
                  );
                  final zoneScore = StringSimilarity.compareTwoStrings(
                    zone,
                    lowerQuery,
                  );

                  // Combine both scores (weight name higher if needed)
                  final combinedScore = (nameScore + zoneScore);

                  return MapEntry(station, combinedScore);
                })
                .where(
                  (entry) =>
                      entry.value > 0.7 || // Similarity threshold
                      entry.key[2]?.toString().toLowerCase().contains(
                            lowerQuery,
                          ) ==
                          true ||
                      entry.key[1]?.toString().toLowerCase().contains(
                            lowerQuery,
                          ) ==
                          true,
                )
                .toList();

        // Sort stations by score descending
        scoredList.sort((a, b) => b.value.compareTo(a.value));

        // Extract only the station entries
        filteredStations = scoredList.map((entry) => entry.key).toList();
      } else {
        filteredStations = orignalStations;
      }
    });
  }

  Future<List> loadStationsFromCSV() async {
    //fetching data from CSV file logic
    final rawData = await rootBundle.loadString('assets/Map/stops.csv');
    final List<List<dynamic>> rows = await Isolate.run(() {
      return CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        textDelimiter: '"',
        shouldParseNumbers: false,
      ).convert(rawData);
    });
    print("Total rows parsed: ${rows}");
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          backBox(context, _controller1, _controller2), //leave as is
          screenName(), //leave as is
          Stack(
            //adding the search cluster here
            alignment: Alignment.centerLeft,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20, left: 40, top: 20),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 0),
                      //color: const Color.fromARGB(255, 8, 8, 8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 234, 234, 234),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10), //40
                    ),
                    //width: double.infinity,
                    height: 100,
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
                                color: const Color.fromARGB(255, 132, 132, 132),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 179, 179, 179),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 50, 50, 50),
                          height: 1,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 0, 10, 5),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            focusNode: _focusNode2,
                            cursorOpacityAnimates: true,
                            controller: _controller2,
                            onChanged: filterStationsLogic,
                            // onSubmitted: (_) {
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder: (context) {
                            //         //logic to push user to route screen
                            //         return const routeScreen(); //integrate a checking condition whether both stations have been entered or not
                            //       },
                            //     ),
                            //   );
                            // }, //add the logic to navigate to next screen whenever available
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "To",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 132, 132, 132),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            style: TextStyle(
                              color: const Color.fromARGB(255, 179, 179, 179),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              fromToIcon(),
            ], //add flip circle function flipcircle()
          ),
          stationList(
            filteredStations,
            _controller1,
            _controller2,
            _focusNode1,
            _focusNode2,
          ),
        ],
      ),
    );
  }
}

backBox(BuildContext context, _controller1, _controller2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        //back button sized box
        height: 50,
        child: GestureDetector(
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
                CupertinoIcons
                    .back, //check if the icon gesture detector working
                color: const Color.fromARGB(255, 47, 130, 255),
              ),
              Text(
                "Back",
                style: TextStyle(
                  color: const Color.fromARGB(255, 47, 130, 255),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(
        //submit button sized box
        height: 50,
      ),
      GestureDetector(
        onTap: () {
          ScreenTransferController(
            context,
            _controller1.text,
            _controller2.text,
          );
        },

        child: Row(
          children: [
            Text(
              "Done",
              style: TextStyle(
                color: const Color.fromARGB(255, 47, 130, 255),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: 18,
              ),
            ),
            Icon(
              CupertinoIcons.forward,
              color: const Color.fromARGB(255, 47, 130, 255),
            ),
          ],
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
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget fromToIcon() {
  //icons on the left side of the search box
  return Container(
    child: Column(
      children: [
        Icon(CupertinoIcons.circle, color: Colors.white),
        Icon(Icons.arrow_drop_down, color: Colors.white),
        //Icon(CupertinoIcons.resize_v, color: Colors.white),
        Icon(CupertinoIcons.square, color: Colors.white),
      ],
    ),
  );
}

// Widget ListViewed() {
//   return
// }
///////////////////////////////////////////-----------------------------------
class StationType {
  final String zone;
  final String name;

  StationType({required this.zone, required this.name});

  // @override
  // String toString() => 'StationType(name: $name, zone: $zone)';
}

Future<List<StationType>> loadStationsFromCSV() async {
  try {
    final rawData = await rootBundle.loadString('assets/Map/stops.csv');
    print("length: ${rawData}");

    final List<List<dynamic>> rows = await Isolate.run(() {
      return CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        textDelimiter: '"',
        shouldParseNumbers: false,
      ).convert(rawData);
    });
    print("length: ${rows.length}");

    //print("Total rows parsed: ${rows.length}");

    final stations =
        rows
            .where(
              (row) =>
                  row.length > 3 &&
                  row[2] != null &&
                  row[3] != null &&
                  row[2].toString().trim().isNotEmpty &&
                  row[3].toString().trim().isNotEmpty,
            )
            .map((row) {
              print("leng: $row");
              return StationType(
                name: row[1].toString().trim(),
                zone: row[2].toString().trim(),
              );
            })
            .toList();

    print("Successfully created ${stations.length} stations");
    print('leng detail: $stations');
    return stations;
  } catch (e, stackTrace) {
    print("Error loading CSV: $e");
    print("Stack trace: $stackTrace");
    return [];
  }
}

bool fieldvalidator1 = false;
bool fieldvalidator2 = false;
List<dynamic> coreTransferStations = [];

Widget stationList(
  //rather than sending direct names of stations to route searching algorithm send the station list
  List<dynamic> stations,
  _controller1,
  _controller2,
  _focusNode1,
  _focusNode2,
) {
  if (stations.isEmpty) {
    print("controller is $_controller1");
    return const Center(
      child: CupertinoActivityIndicator(color: Colors.white, radius: 15),
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
        String line = station[3].toString();
        line = line.replaceAll(RegExp(r'[\[\]]'), '');
        List<String> parts = line.split('-');
        List<int> lineNumbers = parts.map((e) => int.parse(e)).toList();
        print("Line numbers: $lineNumbers");
        String name = station[2].toString(); // Station Name
        String zone = station[1].toString(); // Zone

        return InkWell(
          focusColor: const Color.fromARGB(0, 255, 255, 255),
          splashColor: const Color.fromARGB(86, 76, 76, 76),
          onTap: () {
            print("ControllerName: $name");
            if (_focusNode1.hasFocus) {
              //inputs text in the text filed on tap
              //filteredStations; //check why the recommedation is not reverting back to orginal list after changing focus
              _controller1.text = name;
              FocusScope.of(context).requestFocus(_focusNode2);
              fieldvalidator1 = true;
              coreTransferStations.add(station);
              //print("filed1 is $fieldvalidator1");

              // filteredStationsLogic;
              // filteredStations = orignalStations;

              //filteredStations;
            }
            if (_focusNode2.hasFocus) {
              _controller2.text = name;
              fieldvalidator2 = true;
              coreTransferStations.add(station);

              ScreenTransferController(
                context,
                _controller1.text,
                _controller2.text,
              );
            } else {
              _focusNode1.requestFocus();
              _controller1.text = name;
              FocusScope.of(context).requestFocus(_focusNode2);
            }
            //_controller1.text = name;
            //FocusScope.of(context).requestFocus(_focusNodeTo);
          },
          child: stationUnit(name: name, zone: zone, lines: lineNumbers),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Color.fromARGB(255, 27, 27, 27), height: 1);
      },
    ),
  );
}

ScreenTransferController(context, source, destination) {
  //transition list working but has an bug that keeps adding the source and desitnimation staiotn everytime we go ahead and back fix this , send this to route calculating algorithm
  print(
    "the transition is from $source to $destination and the core list is $coreTransferStations",
  );
  //sends user to next route screen
  if (fieldvalidator2 && fieldvalidator1) {
    //same as done button checks and validabetes if both staitons have been inputed correctly
    //checks if both fileds are populated or not
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const routeScreen()),
    );
  } else {
    final snackBar = SnackBar(
      content: const Text('Please select both departure and arrival correctly'),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

coreSourceDestinationList() {}
