import 'dart:math';
import 'dart:ui';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:neopop/neopop.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import './MapDir/mapMetro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vibration/vibration.dart';
import './ServicesDir/Station_element.dart';
import 'search.dart';
import './StationDir/stopInfo.dart';
import './MapDir/svgMap.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 8, 8),
      body: metroHomeScreen(),
    ); //add this inside an scaffold
    // return metroScreen(context);
  }
}

class metroHomeScreen extends StatefulWidget {
  const metroHomeScreen({super.key});

  @override
  State<metroHomeScreen> createState() => _metroHomeScreenState();
}

class _metroHomeScreenState extends State<metroHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: [
          //InfoBar(),
          Expanded(child: appFooter(context)),
          searchBar(
            context,
          ), //there is a feature in flutter for hero widget that transitions smoothly between screen transitions
          suggestions(context),
          Divider(thickness: 0, color: const Color.fromARGB(0, 35, 35, 35)),
          nearYou(context),
          Divider(thickness: 0, color: const Color.fromARGB(0, 35, 35, 35)),
          ticketAndExit(context),
          InfoBar(),
        ],
      ),
    );
  }
}

class InfoBar extends StatelessWidget {
  // stateless widget for informatics bar
  const InfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: processedHeight(context, 0.04, 35, 35),
      decoration: const BoxDecoration(color: Color.fromARGB(255, 8, 8, 8)),
      width: double.infinity,
      child: Marquee(
        //adding marquee effect to text with help of the package
        text:
            "DELHI METRO WELCOMES YOU * ALL METRO LINES OPERATING ON SCHEDULE *", //Hard coded text for now, will add an feature to dyanmically change it
        blankSpace: 20,
        style: TextStyle(
          fontFamily: 'Doto',
          color: Color.fromARGB(255, 230, 81, 0),
          fontSize: 18,
          fontWeight: FontWeight.w200,
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
        CupertinoPageRoute(builder: (context) => const SearchScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      height: processedHeight(context, 0.05, 45, 45),
      //height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0), //remove later if not used
        ),
        color: const Color.fromARGB(255, 224, 224, 224),
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
              fontSize: processedFontheight(context),
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
    height: processedHeight(context, 0.10, 90, 90),
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
    height: processedHeight(context, 0.15, 125, 125),
    //height: MediaQuery.of(context).size.height * 0.18,
    margin: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Near you",
          style: TextStyle(
            color: Colors.white,
            fontSize: processedFontheight(context),
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
    height: 60, //processedHeight(context, 0.1, 50, 70),
    //height: MediaQuery.of(context).size.height * 0.1,
    // decoration: BoxDecoration(
    //   border: Border(
    //     bottom: BorderSide(color: const Color.fromARGB(255, 35, 35, 35)),
    //   ),
    // ),
    margin: const EdgeInsets.all(5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              //color: const Color.fromARGB(255, 17, 17, 17),
              border: Border.all(color: const Color.fromARGB(255, 35, 35, 35)),
            ),
            child: GestureDetector(
              behavior:
                  HitTestBehavior
                      .opaque, // to make sure that when tapped on white space the button is tapped
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => stopInfoScreen()),
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "stop info",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    fontSize: processedFontheight(context),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
          // height: 50,
          // child: VerticalDivider(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
        // Container(
        //   width: 1,
        //   height: 50,
        //   color: const Color.fromARGB(255, 35, 35, 35),
        //   margin: EdgeInsets.symmetric(horizontal: 10),
        // ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: const Color.fromARGB(255, 35, 35, 35)),
              //color: const Color.fromARGB(255, 17, 17, 17),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => mapMetroScreen()),
                );
              },
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "metro map",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 224, 224, 224),
                    fontSize: processedFontheight(context),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
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

// appFooter() {
//   return
// }

appFooter(context) {
  return Container(
    //height: processedHeight(context, 0.45, 300, 400),
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
      image: const DecorationImage(
        image: AssetImage('assets/Image/carfooter.jpg'),
        fit: BoxFit.cover,
      ),
    ),

    // child: Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(
    //       margin: EdgeInsets.all(20),
    //       child: Text(
    //         "New Delhi \nDelay on red line",
    //         style: TextStyle(
    //           color: const Color.fromARGB(255, 230, 81, 0),
    //           fontSize: 25,
    //           fontFamily: 'Doto',
    //           fontWeight: FontWeight.w400,
    //         ),
    //       ),
    //     ),
    //   ],
    // ),
  );
}

double processedHeight(context, factorMax, minSize, prefferedHeight) {
  //not working in split view, solve that bug
  try {
    print("Factor Max is $factorMax");
    double finalHeight;
    double height =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double width = MediaQuery.of(context).size.width;
    print("HEIGHT IS $height");
    print("WIDTH IS $width ");
    double maxHeight = height * factorMax;
    if (maxHeight == double.infinity || maxHeight.isNaN) {
      maxHeight = prefferedHeight; // or some other default value
    }
    double minHeight = minSize.toDouble();
    if (height < 700) {
      //checks if phone multiview or normal screen

      finalHeight =
          maxHeight
              .clamp(
                minHeight,
                height,
              ) //bit of scrolling is inevitbale, so let it be
              .toDouble(); //SOLVED: right now it has a bit of empty space at the bottom on some screens that are large, make it so that everyscreen has height derieved from screen height and preferred heigth is taken only when that cant be applied
      print("FINAL HEIGHT IS $finalHeight");
    } else {
      print("using preffered height");
      finalHeight = maxHeight = height * factorMax;
    }

    return finalHeight;
  } catch (e) {
    print("Error processing height: $e ");
    return prefferedHeight.toDouble();
  }
}

double processedFontheight(context) {
  double width = MediaQuery.of(context).size.width;
  if (width < 600) {
    print("18");
    return 18;
  }
  if (width >= 600) {
    print("22");
    return 22;
  } else {
    print("18");
    return 18;
  }
}
