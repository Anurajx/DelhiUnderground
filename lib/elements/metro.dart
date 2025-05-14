import 'dart:math';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'svgMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'map.dart';
import 'package:marquee/marquee.dart';
import 'package:vibration/vibration.dart';
import 'Station_element.dart';
import 'search.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return showBottomSheet(context);
  }
}

showBottomSheet(BuildContext context) {
  //created a seprate function to dynamically open and close the bottom sheet
  return Stack(
    //stacks arranges componets in Z-axis so be careful while using it
    children: [
      SvgMap(),
      //MapScreen(), //add the bottom sheet size so that the map can be seen
      DraggableScrollableSheet(
        //make this a seprate function so that it can be reused for station info screen
        initialChildSize: 1,
        minChildSize: 0.12,
        //maxChildSize: 0.9,
        snap: false,

        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 8, 8, 8),
            ),
            child: SingleChildScrollView(
              //controller: scrollController,
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InfoBar(), //adding info bar to scaffold
                  //searchBar(),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ), //only hornizontally padded to outer container
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 8, 8, 8),
                    ),
                    child: Column(
                      //new children inside the container for adding an padding and an border around elements
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 35, 35, 35),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              searchBar(context),
                              suggestions(),
                              Divider(
                                thickness: 1,

                                color: const Color.fromARGB(255, 35, 35, 35),
                              ),
                              nearYou(),
                              Divider(
                                thickness: 1,
                                color: const Color.fromARGB(255, 35, 35, 35),
                              ),
                              ticketAndExit(),
                              FooterMap(),
                            ],
                          ), // creating another child children pair to add an outline across all elements
                        ),
                      ],
                    ),
                  ),
                ], // add after eating allt hat needs to go inside the bottom sheet.........................
              ),
            ),
          );
        },
      ),
    ],
  );
}

class InfoBar extends StatelessWidget {
  // stateless widget for informatics bar
  const InfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 8, 8, 8)),
      width: double.infinity,
      height: 40,
      child: Marquee(
        //adding marquee effect to text with help of the package
        text:
            "DELHI METRO MEIN AAPKA SWAGAT HAI * DELHI METRO WELLCOMES YOU *", //Hard coded text for now, will add an feature to dyanmically change it
        blankSpace: 20,
        style: TextStyle(
          fontFamily: 'Doto',
          color: Color.fromARGB(255, 230, 81, 0),
          fontSize: 20,
        ),
      ),
    );
  }
}

//

searchBar(BuildContext context) {
  //search bar widget when tapped a new screen opens where user can enter departure and concorse
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 234, 234),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Where to',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: const Color.fromARGB(201, 15, 15, 15),
            ),
          ),
          Icon(CupertinoIcons.search),
        ],
      ),
    ),
  );
}

suggestions() {
  return Container(
    margin: const EdgeInsets.all(5),
    width: double.infinity,
    height: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Station(name: 'RK Puram'), Station(name: 'Rajouri Garden')],
    ),
  );
}

nearYou() {
  return Container(
    width: double.infinity,
    height: 105,
    margin: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NEAR YOU",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Station(name: "Bhikaji Cama Place"),
        Station(name: "South Extension"),
      ],
    ),
  );
}

ticketAndExit() {
  return InkWell(
    onTap: () {
      //ADD APP LOGIC HERE FOR NEXT SCREEN
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "EXIT GATES",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            CupertinoIcons.map,
            color: const Color.fromARGB(255, 179, 179, 179),
          ),
        ],
      ),
    ),
  );
}

// appFooter() {
//   return
// }

class FooterMap extends StatefulWidget {
  const FooterMap({super.key});

  @override
  State<FooterMap> createState() => _FooterMapState();
}

class _FooterMapState extends State<FooterMap> {
  bool _showBlur = true;

  void _removeBlur() {
    setState(() {
      _showBlur = false; // Disable the entire layer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 420,
      child: Stack(
        children: [
          SvgMap(),
          if (_showBlur)
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeBlur,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      color: const Color.fromARGB(120, 0, 0, 0),
                      child: Center(
                        child: Text(
                          "METRO MAP",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 94, 94, 94),
                            fontSize: 30,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
