import 'dart:math';
import 'dart:ui';
import 'package:neopop/neopop.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'svgMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return metroScreen(context);
  }
}

metroScreen(BuildContext context) {
  //created a seprate function to dynamically open and close the bottom sheet
  return Container(
    decoration: BoxDecoration(color: const Color.fromARGB(255, 8, 8, 8)),
    child: ListView(
      //you can now remove list view as i have modified back button to make sure keyboard closes before going back
      children: [
        Column(
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
                    // decoration: BoxDecoration(
                    //   border: Border.all(
                    //     color: const Color.fromARGB(255, 35, 35, 35),
                    //   ),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        appFooter(),
                        searchBar(
                          context,
                        ), //there is a feature in flutter for hero widget that transitions smoothly between screen transitions
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
                      ],
                    ), // creating another child children pair to add an outline across all elements
                  ),
                ],
              ),
            ),
          ], // add after eating allt hat needs to go inside the bottom sheet.........................
        ),
      ],
    ),
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
            "DELHI METRO MEIN AAPKA SWAGAT HAI * DELHI METRO WELCOMES YOU *", //Hard coded text for now, will add an feature to dyanmically change it
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0), //remove later if not used
        ),
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
      children: [
        stationPrimitive(name: 'RK Puram'),
        stationPrimitive(name: 'Rajouri Garden'),
      ],
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
        stationPrimitive(name: "Bhikaji Cama Place"),
        stationPrimitive(name: "South Extension"),
      ],
    ),
  );
}

ticketAndExit() {
  // chat gpt
  return InkWell(
    onTap: () {
      // ADD APP LOGIC HERE FOR NEXT SCREEN
    },
    child: Container(
      width: double.infinity,
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(color: const Color.fromARGB(255, 35, 35, 35)),
      //   ),
      // ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "EXIT GATES",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 50,
            child: VerticalDivider(
              color: const Color.fromARGB(255, 35, 35, 35),
            ),
          ),
          // Container(
          //   width: 1,
          //   height: 50,
          //   color: const Color.fromARGB(255, 35, 35, 35),
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          // ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "METRO MAP",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// appFooter() {
//   return
// }

appFooter() {
  return Container(
    //width: double.infinity,
    //margin: EdgeInsets.all(0),
    height:
        420, //right now the hrigh of container is hard coded make by mkaing it expanded
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      image: DecorationImage(
        image: AssetImage('assets/Image/Appfooter.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 222, 222, 222),
            highlightColor: const Color.fromARGB(255, 153, 153, 153),
            child: Text(
              "New Delhi",
              style: TextStyle(
                //color: const Color.fromARGB(255, 216, 216, 216),
                fontSize: 40,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
