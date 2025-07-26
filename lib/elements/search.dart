// import 'dart:ffi';
// import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:metroapp/elements/ServicesDir/data_Provider.dart';
import 'package:provider/provider.dart';
// import 'package:neopop/neopop.dart';
import 'route.dart';
//import './ServicesDir/metroStationsList.dart';
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
  //bool _shouldClear = false;

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      setState(() {
        filterStationsLogic(_controller1.text);

        ///FUCKKKKK YESSSS
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
    loadStationsFromCSV().then((stations) {
      setState(() {
        orignalStations = stations;
        filteredStations = stations;
      });
    });
  }

  @override
  void deactivate() {
    // when the router is poped and user goes back to home screen this is triggered
    super.deactivate();
    // context.read<DataProvider>().updateCoreTransferStationsDict({
    // });
    if (!Navigator.canPop(context)) {
      coreTransferStationsDict.clear();
    }
  }
  //////////////

  void filterStationsLogic(String query) {
    //Logiv to find the best match
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
    //IF I EVER CHANGE TO JSON CHANGE IT HERE TO MAKE A LIST OUT OF IT
    //fetching data from CSV file logic
    try {
      final rawData = await rootBundle.loadString(
        'assets/Map/stops.csv',
      ); //stops
      final List<List<dynamic>> rows = await Isolate.run(() {
        return CsvToListConverter(
          eol: '\n',
          fieldDelimiter: ',',
          textDelimiter: '"',
          shouldParseNumbers: false,
        ).convert(rawData);
      });
      return rows;
    } catch (e) {
      return [];
      //error protection
    }
    //print("Total rows parsed: ${rows}");
    //return rows;
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
          backBox(context, _controller1, _controller2), //leave as is
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
                    height: 90,
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
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Divider(
                          color: const Color.fromARGB(255, 8, 8, 8),
                          height: 1,
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
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: const Color.fromARGB(255, 130, 130, 130),
                    thickness: 0.2,
                    height: 1,
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
          ),
        ],
      ),
    );
  }
}

backBox(BuildContext context, controller1, controller2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        //back button sized box
        height: 50,
        child: GestureDetector(
          onTap: () {
            HitTestBehavior.opaque;
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
      //Icon(Icons.route, color: const Color.fromARGB(255, 175, 175, 175)),
    ],
  );
}

screenName() {
  //Plan your trip box
  return Center(
    child: Text(
      "Plan your trip",
      style: TextStyle(
        color: Color.fromARGB(255, 139, 139, 139),
        fontSize: 20,
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

Map<String, List<dynamic>> coreTransferStationsDict = {
  //used for transfer screen process, making sure both source and destination are available
  //Dictionary format
  'Source': [], //adding some defaults
  'Destination': [],
};

Widget stationList(
  // widget that is expanded and scrollable of stations at bottom
  List<dynamic> stations,
  controller1,
  controller2,
  focusNode1,
  focusNode2,
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
        String line = station[3].toString();
        line = line.replaceAll(RegExp(r'[\[\]]'), '');
        List<String> parts = line.split('-');
        List<int> lineNumbers = parts.map((e) => int.parse(e)).toList();
        //print("Line numbers: $lineNumbers");
        String name = station[2].toString(); // Station Name
        String hindiName =
            station[1].toString(); // not hindiName actually hindi name

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
              coreTransferStationsDict['Source'] =
                  station; ////-- setting name to be sent to search algorithm
              if (ifDestinationSelected() && ifSourceSelected()) {
                /////////NEWLY ADDED-------------
                print("Destination selected ${controller2.text}");
                screenTransferController(
                  context,
                  controller1, //changed
                  controller2,
                );
              } else {
                focusNode2.requestFocus();
              }
            }
            if (focusNode2.hasFocus) {
              print("coreTransferStationsDict is focus node 2 fault");
              controller2.text = name;
              coreTransferStationsDict['Destination'] = station;

              // screenTransferController(
              //   context,
              //   controller1.text,
              //   controller2.text,
              // );
              if (ifSourceSelected() && ifDestinationSelected()) {
                /////////NEWLY ADDED-------------
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
          child: stationUnit(
            name: name,
            hindiName: hindiName,
            lines: lineNumbers,
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
    if (coreTransferStationsDict['Source']![2] != source ||
        coreTransferStationsDict['Destination']![2] != destination) {
      //confirms user input if there is a mismatch between dictionary and textfield
      showDialog(
        //warns user with that BIG GREEN BOX for mis match
        context: context,
        builder:
            (context) => AlertDialog(
              backgroundColor: const Color.fromARGB(255, 31, 200, 127),
              title: Text(
                "${coreTransferStationsDict['Source']![2]} to ${coreTransferStationsDict['Destination']![2]}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
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
                            (context) => routeScreen(
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
              (context) => routeScreen(
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
