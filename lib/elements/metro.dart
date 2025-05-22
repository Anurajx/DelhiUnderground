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
import 'stopInfo.dart';
import 'mapMetro.dart';

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
    //height: MediaQuery.of(context).size.height
    decoration: BoxDecoration(color: const Color.fromARGB(255, 8, 8, 8)),
    child: Column(
      //you can now remove list view as i have modified back button to make sure keyboard closes before going back
      children: [
        InfoBar(), //adding info bar to scaffold
        //searchBar(),
        Flexible(
          child: Container(
            //width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ), //only hornizontally padded to outer container
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 8, 8, 8),
            ),
            child: ListView(
              physics: BouncingScrollPhysics(),
              //new children inside the container for adding an padding and an border around elements
              children: [
                Container(
                  //height: double.infinity,
                  // padding: EdgeInsets.only(
                  //   bottom: MediaQuery.of(context).padding.bottom,
                  // ),
                  //padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  //width: MediaQuery.of(context).size.width,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: const Color.fromARGB(255, 35, 35, 35),
                  //   ),
                  // ),
                  //432
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      appFooter(context),
                      searchBar(
                        context,
                      ), //there is a feature in flutter for hero widget that transitions smoothly between screen transitions
                      suggestions(context),
                      Divider(
                        thickness: 1,

                        color: const Color.fromARGB(255, 35, 35, 35),
                      ),
                      nearYou(context),
                      Divider(
                        thickness: 1,
                        color: const Color.fromARGB(255, 35, 35, 35),
                      ),
                      ticketAndExit(context),
                    ],
                  ), // creating another child children pair to add an outline across all elements
                ),
              ],
            ),
          ),
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
      height: processedHeight(context, 0.05, 35, 35),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 8, 8, 8)),
      width: double.infinity,
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

searchBar(context) {
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
      height: processedHeight(context, 0.06, 45, 45),
      //height: MediaQuery.of(context).size.height * 0.06,
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

suggestions(context) {
  return Container(
    margin: const EdgeInsets.all(5),
    width: double.infinity,
    height: processedHeight(context, 0.12, 90, 90),
    //context, 0.125, 60, 80
    //height: MediaQuery.of(context).size.height * 0.125,
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

nearYou(context) {
  return Container(
    width: double.infinity,
    height: processedHeight(context, 0.17, 125, 125),
    //height: MediaQuery.of(context).size.height * 0.18,
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
        stationNearby(name: "Bhikaji Cama Place"),
        stationNearby(name: "South Extension"),
      ],
    ),
  );
}

ticketAndExit(context) {
  // chat gpt
  return Container(
    width: double.infinity,
    height: processedHeight(context, 0.1, 50, 70),
    //height: MediaQuery.of(context).size.height * 0.1,
    // decoration: BoxDecoration(
    //   border: Border(
    //     bottom: BorderSide(color: const Color.fromARGB(255, 35, 35, 35)),
    //   ),
    // ),
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            behavior:
                HitTestBehavior
                    .opaque, // to make sure that when tapped on white space the button is tapped
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => stopInfoScreen()),
              );
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "STOP INFO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
          height: 50,
          child: VerticalDivider(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
        // Container(
        //   width: 1,
        //   height: 50,
        //   color: const Color.fromARGB(255, 35, 35, 35),
        //   margin: EdgeInsets.symmetric(horizontal: 10),
        // ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mapMetroScreen()),
              );
            },
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
        ),
      ],
    ),
  );
}

// appFooter() {
//   return
// }

appFooter(context) {
  return Container(
    height: processedHeight(context, 0.40, 300, 400),
    // height:
    //     MediaQuery.of(context).size.height *
    //     0.4, //this is genius idk how i did this but why not, height is equal to width of screen
    //width: double.infinity,
    //margin: EdgeInsets.all(0),
    // height:
    //     420, //right now the hrigh of container is hard coded make by mkaing it expanded
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

double processedHeight(context, factorMax, minSize, prefferedHeight) {
  //not working in split view, solve that bug
  try {
    double finalHeight;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("HEIGHT IS $height");
    print("WIDTH IS $width ");
    double maxHeight = height * factorMax;
    if (maxHeight == double.infinity || maxHeight.isNaN) {
      maxHeight = prefferedHeight; // or some other default value
    }
    double minHeight = minSize.toDouble();
    if (width > 600) {
      //checks if phone or tab
      //960 moto
      //841 samsung

      finalHeight = maxHeight.clamp(minHeight, height).toDouble();
      print("FINAL HEIGHT IS $finalHeight");
    } else {
      print("using preffered height");
      finalHeight = prefferedHeight.toDouble();
    }

    return finalHeight;
  } catch (e) {
    print("Error processing height: $e ");
    return prefferedHeight.toDouble();
  }
}
