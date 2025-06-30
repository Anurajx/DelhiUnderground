import 'dart:ffi';
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
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 8, 8, 8),
        body: searchBody(context: context),
        //resizeToAvoidBottomInset: true,
      ),
    );
  }
}

class searchBody extends StatefulWidget {
  final dynamic context;

  const searchBody({super.key, required this.context});

  @override
  State<searchBody> createState() => _searchBodyState();
}

class _searchBodyState extends State<searchBody> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeTo = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  List<dynamic> orignalStations = [];
  List<dynamic> filteredStations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    loadStationsFromCSV().then((stations) {
      setState(() {
        //print("Stations is $Stations");
        orignalStations = stations;
        //print("Stations is $stations");
        filteredStations = stations;

        print("filteredStations is $filteredStations");
        //print("filteredStations is $filteredStations");
      });
    });
  }

  void filterStations(String query) {
    //filtered station not wroking properly correct it
    //search logic to find station
    final lowerQuery = query.toLowerCase();
    setState(() {
      if (query != "") {
        filteredStations =
            orignalStations.where((station) {
              if (station.length >= 1) {
                //print("filter station suggestion $stations[1]");
                final name = station[2]?.toString().toLowerCase();
                final zone = station[1]?.toString().toLowerCase();
                //print("name is $name zone is $zone");
                final nameScore = StringSimilarity.compareTwoStrings(
                  name,
                  lowerQuery,
                );
                print("nameScore is $nameScore");
                final zoneScore = StringSimilarity.compareTwoStrings(
                  zone,
                  lowerQuery,
                );
                if (nameScore > 0.5 || zoneScore > 0.5) {
                  return true;
                }
                return name!.contains(lowerQuery) || zone!.contains(lowerQuery);
                //return name!.contains(lowerQuery) || zone!.contains(lowerQuery);
              }
              return false;
            }).toList();

        //print("filteredStations is $filteredStations");
      } else {
        filteredStations = orignalStations;
        //print("falseeeeeee user request ${List.from(orignalStations)}");
      }
      //print("filteredStations is $filteredStations");
      // var name = stations[0].name;
      // var zone = stations[0].name;
      // stationList(name, zone);
      //print("filteredStations is $filteredStations");
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
          backBox(context), //leave as is
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
                            focusNode: _focusNode,
                            cursorOpacityAnimates: true,
                            controller: _controller1,
                            onChanged: filterStations,
                            //onChanged: filterStations,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_focusNodeTo);
                            },
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "From",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 132, 132, 132),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
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
                            focusNode: _focusNodeTo,
                            cursorOpacityAnimates: true,
                            controller: _controller2,
                            onSubmitted: (_) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) {
                                    //logic to push user to route screen
                                    return const routeScreen(); //integrate a checking condition whether both stations have been entered or not
                                  },
                                ),
                              );
                            }, //add the logic to navigate to next screen whenever available
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "To",
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 132, 132, 132),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //stationList("okayy", "nicee"),
                  // stations.length >= 2
                  //     ? SizedBox(
                  //       height: 300,
                  //       child: stationList(stations[0].name, stations[2].zone),
                  //     )
                  //     : const CircularProgressIndicator(),
                ],
              ),
              fromToIcon(),
            ], //add flip circle function flipcircle()
          ),
          stationList(
            filteredStations,
          ), //apply the logic that the this compoents intself takes out usefull vaues out of the list of lists
          // searchLogic(),
          //finalSearch(),
        ],
      ),
    );
  }
}

backBox(BuildContext context) {
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
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const routeScreen()),
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

// Widget stationList(station) {
//   print("Finalised list: $station");
//   station = [];
//   //print("Station list called for $name and $zone");
//   if (station != []) {
//     return Expanded(
//       child: ListView.separated(
//         itemCount: metroStations.length,
//         itemBuilder: (context, index) {
//           String stationID = metroStations.keys.elementAt(index);
//           var stationName = metroStations[stationID];
//           return stationUnit(name: " station[12][2]", zone: "station[12][1]");
//         },
//         separatorBuilder: (context, index) {
//           return const Divider(
//             color: Color.fromARGB(255, 27, 27, 27),
//             height: 30,
//           );
//         },
//       ),
//     );
//   } else {
//     return CircularProgressIndicator();
//   }
// }

Widget stationList(List<dynamic> stations) {
  if (stations.isEmpty) {
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
          onTap: () {},
          child: stationUnit(name: name, zone: zone, lines: lineNumbers),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Color.fromARGB(255, 27, 27, 27),
          height: 30,
        );
      },
    ),
  );
}

// Widget stationList(station) {
//   return ListView.builder(
//     itemCount: metroStations.length,
//     itemBuilder: (context, index) {
//       return stationUnit(name: station[2], zone: "station[12][1]");
//     },
//   );
// }


//return stationUnit(name: station[12][2], zone: "station[12][1]");