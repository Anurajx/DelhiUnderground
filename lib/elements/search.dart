import 'dart:ffi';
import 'package:neopop/neopop.dart';

import 'metroStationsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Station_element.dart';

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
        backgroundColor: Colors.black,
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
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        backBox(context),
        searchCluster(),
        ListViewed(),
        //finalSearch(),
      ],
    ),
  );
}

backBox(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: GestureDetector(
      onTap: () {
        Navigator.pop(context);
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
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

searchCluster() {
  return Stack(
    alignment: Alignment.center,
    children: [searchBoxed()], //add flip circle function flipcircle()
  );
}

flipCircle() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 26, 26, 26),
      borderRadius: BorderRadius.circular(40),
    ),
    width: 35,
    height: 35,
    child: Icon(
      CupertinoIcons.chevron_up_chevron_down,
      color: const Color.fromARGB(255, 234, 234, 234),
    ),
  );
}

class searchBoxed extends StatefulWidget {
  const searchBoxed({super.key});

  @override
  State<searchBoxed> createState() => _searchBoxedState();
}

class _searchBoxedState extends State<searchBoxed> {
  final FocusNode _focusNode = FocusNode();
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
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 8, 8, 8),
        border: Border.all(
          color: const Color.fromARGB(255, 234, 234, 234),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20), //40
      ),
      width: double.infinity,
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 10, 0),
            child: TextField(
              focusNode: _focusNode,
              cursorOpacityAnimates: true,
              cursorColor: const Color.fromARGB(255, 234, 234, 234),
              controller: _controller1,
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: "From",
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          //Divider(color: const Color.fromARGB(255, 89, 89, 89)),
          Container(
            margin: const EdgeInsets.fromLTRB(15, 0, 10, 5),
            child: TextField(
              cursorOpacityAnimates: true,
              cursorColor: const Color.fromARGB(255, 234, 234, 234),
              controller: _controller2,
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: "To",
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
          height: 25,
        );
      },
    ),
  );
}

finalSearch() {
  return NeoPopButton(
    color: Colors.black,
    bottomShadowColor: const Color.fromARGB(255, 37, 37, 37),
    rightShadowColor: Colors.black,
    onTapUp: () {},
    border: Border.all(color: Colors.lightGreenAccent),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text("Search", style: TextStyle(color: Colors.white))],
      ),
    ),
  );
}
