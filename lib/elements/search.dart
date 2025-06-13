import 'dart:ffi';
import 'package:neopop/neopop.dart';
import 'route.dart';
import './ServicesDir/metroStationsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './ServicesDir/Station_element.dart';

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
        body: searchBody(context),
        resizeToAvoidBottomInset: true,
      ),
    );
  }
}

searchBody(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        backBox(context),
        screenName(),
        //SizedBox(height: 15),
        searchCluster(),
        ListViewed(),
        //finalSearch(),
      ],
    ),
  );
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

searchCluster() {
  return Stack(
    alignment: Alignment.centerLeft,
    children: [
      searchBoxed(),
      fromToIcon(),
    ], //add flip circle function flipcircle()
  );
}

// flipCircle() {
//   return Container(
//     decoration: BoxDecoration(
//       color: const Color.fromARGB(255, 26, 26, 26),
//       borderRadius: BorderRadius.circular(40),
//     ),
//     width: 35,
//     height: 35,
//     child: Icon(
//       CupertinoIcons.chevron_up_chevron_down,
//       color: const Color.fromARGB(255, 234, 234, 234),
//     ),
//   );
// }

class searchBoxed extends StatefulWidget {
  const searchBoxed({super.key});

  @override
  State<searchBoxed> createState() => _searchBoxedState();
}

class _searchBoxedState extends State<searchBoxed> {
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNodeTo = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Divider(color: const Color.fromARGB(255, 50, 50, 50), height: 1),
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
    );
  }
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

Widget ListViewed() {
  return Expanded(
    child: ListView.separated(
      itemCount: metroStations.length,
      itemBuilder: (context, index) {
        String stationID = metroStations.keys.elementAt(index);
        var stationName = metroStations[stationID];
        return Station(name: stationName!["name"]);
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

// finalSearch() {
//   return NeoPopButton(
//     color: Colors.black,
//     bottomShadowColor: const Color.fromARGB(255, 37, 37, 37),
//     rightShadowColor: Colors.black,
//     onTapUp: () {},
//     border: Border.all(color: Colors.lightGreenAccent),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [Text("Search", style: TextStyle(color: Colors.white))],
//       ),
//     ),
//   );
// }
