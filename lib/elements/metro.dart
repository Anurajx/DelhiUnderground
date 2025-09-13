import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:metroapp/elements/ServicesDir/geolocatorService.dart';
import 'package:metroapp/elements/StationDir/stopInfo.dart';
import 'package:metroapp/elements/route.dart';
import 'package:metroapp/main.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:metroapp/elements/ServicesDir/whatsappURLTransfer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import './MapDir/mapMetro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import './ServicesDir/Station_element.dart';
import 'search.dart';
import 'StationDir/stationSearch.dart';
import 'ServicesDir/data_Provider.dart';
import 'package:provider/provider.dart';

//import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
//bool showMarquee = true;

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initialize(context));
  }

  @override
  Widget build(BuildContext context) {
    //print(Geolocatorservice());
    return metroHomeScreen();
    // return Scaffold(
    //   backgroundColor: const Color.fromARGB(255, 8, 8, 8),
    //   body: metroHomeScreen(),
    // ); //add this inside an scaffold
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

          //Expanded(child: topHeader()),
          searchBar(
            context,
          ), //there is a feature in flutter for hero widget that transitions smoothly between screen transitions
          suggestions(context),
          Divider(
            thickness: 0,
            color: const Color.fromARGB(0, 35, 35, 35),
            //height: 10,
          ),
          nearYou(context),
          Divider(
            thickness: 0,
            color: const Color.fromARGB(0, 35, 35, 35),
            //height: 10,
          ),
          ticketAndExit(context),

          //Divider(thickness: 0, color: const Color.fromARGB(0, 35, 35, 35)),
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
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(50)),
      blur: 5,
      settings: const LiquidGlassSettings(
        thickness: 10,
        glassColor: Color(0x1AFFFFFF), // A subtle white tint
        lightIntensity: 1.5,
        blend: 40,

        //outlineIntensity: 0.5,
      ),
      child: Container(
        padding: const EdgeInsets.all(0),
        height: 35.h,
        decoration: const BoxDecoration(color: Color.fromARGB(0, 8, 8, 8)),
        width: double.infinity,
        child: Marquee(
          //adding marquee effect to text with help of the package
          text:
              "DELHI SUBWAY - ALL METRO LINES OPERATING ON SCHEDULE ", //Hard coded text for now, will add an feature to dyanmically change it
          blankSpace: 20,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 243, 243, 243),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
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
      height: 45.h,
      //height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0), //remove later if not used
        ),
        color: AppColors.whiteAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Where to',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: AppColors.background,
            ),
          ),
          Icon(CupertinoIcons.search, color: AppColors.background),
        ],
      ),
    ),
  );
}

suggestions(context) {
  return Container(
    margin: const EdgeInsets.all(5),
    width: double.infinity,
    height: 90.h,
    //context, 0.125, 60, 80
    //height: MediaQuery.of(context).size.height * 0.125,
    child: Consumer<DataProvider>(
      builder: (context, data, child) {
        final data =
            Provider.of<DataProvider>(context).coreTransferStationsDict;
        print("transfer data NOT JSON is **$data");
        print(data);
        var just = data["just"];
        var justBefore = data["justBefore"];
        if (data.isNotEmpty &&
            just is List &&
            just.isNotEmpty &&
            justBefore is List &&
            justBefore.isNotEmpty
        //just != [] && justBefore != []
        // data["just"] != null &&
        // data["justBefore"] != null &&
        // data["just"]?[0] != {}
        //data["justBefore"]?[0] != {}
        ) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => routeScreen(
                            coreTransferStationsDict: data["just"]?[0],
                          ),
                    ),
                  );
                },
                child: stationPrimitive(
                  name:
                      data["just"]?[0]["Destination"]?["Name"]
                          .toString(), //CHECK NOT ERROR SAFE
                  //STILL HAS BUG
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => routeScreen(
                            coreTransferStationsDict: data["justBefore"]?[0],
                          ),
                    ),
                  );
                },
                child: stationPrimitive(
                  name:
                      data["justBefore"]?[0]?["Destination"]?["Name"]
                          .toString(), //CHECK NOT ERROR SAFE
                ),
              ),
            ],
          );
        } else {
          //DEFAULT DATA WHEN SAVED SUGGESTIONAS ARE NOT AVAILABLE
          final String defaultData = '''
                        {
                          "just": [
                            {
                              "Source": [59, "हौज खास", "Hauz Khas", [2, 8], 28.543346, 77.206673],
                              "Destination": [44, "विश्वविद्यालय", "Vishwavidyalaya", [2], 28.694765, 77.212418]
                            }
                          ],
                          "justBefore": [
                            {
                              "Source": [52, "सेंट्रल सेक्रेटेरिएट", "Central Secretariat", [2, 6], 28.614973, 77.212029],
                              "Destination": [130, "नेहरू प्लेस", "Nehru Place", [6], 28.551134, 77.251511]
                            }
                          ]
                        }
                        ''';
          final Map<String, dynamic> defaultDataParsed = jsonDecode(
            defaultData,
          );
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: stationPrimitive(
                  name:
                      defaultDataParsed["just"]?[0]["Destination"]?[2]
                          .toString(), //CHECK NOT ERROR SAFE
                  //STILL HAS BUG
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: stationPrimitive(
                  name:
                      defaultDataParsed["justBefore"]?[0]?["Destination"]?[2]
                          .toString(), //CHECK NOT ERROR SAFE
                ),
              ),
            ],
          );
        }
      },
    ),
  );
}

Map<String, Map<String, dynamic>> coreTransferStationsDictNE = {'Source': {}};
Map<String, Map<String, dynamic>> coreTransferStationsDictN = {'Source': {}};

nearYou(context) {
  //bool isNear = false;
  return Container(
    width: double.infinity,
    height: 125.h,
    //height: MediaQuery.of(context).size.height * 0.18,
    margin: EdgeInsets.all(5),
    child: Consumer<DataProvider>(
      builder: (context, data, child) {
        final data = Provider.of<DataProvider>(context).coreNearestStationsDict;
        print("data is $data");
        //print(data.coreNearestStationsDict);
        if (data["Near"] != null && data["NearEnough"] != null) {
          //isNear= !isNear;
          /////////////
          coreTransferStationsDictNE['Source'] =
              data["NearEnough"]![0]; //handles forwording of screen
          String lineNE = data["NearEnough"]![0]["Line"].toString();
          lineNE = lineNE.replaceAll(RegExp(r'[\[\]]'), '');
          List<String> partsNE = lineNE.split('-');
          List<int> lineNumbersNE = partsNE.map((e) => int.parse(e)).toList();
          /////
          coreTransferStationsDictN['Source'] =
              data["Near"]![0]; //handles forwording of screen
          String lineN = data["Near"]![0]["Line"].toString();
          lineN = lineN.replaceAll(RegExp(r'[\[\]]'), '');
          List<String> partsN = lineN.split('-');
          List<int> lineNumbersN = partsN.map((e) => int.parse(e)).toList();
          /////////////
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "NEAR YOU",
                style: TextStyle(
                  color: AppColors.tertiaryText,
                  fontSize: 16.sp, //processedFontheight(context),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),

              // if(isNear){

              // },
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print("NEAR ENOUGH TRIAL69 ${coreTransferStationsDictNE}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => stopInfoScreen(
                            stationDict: coreTransferStationsDictNE,
                          ),
                    ),
                  );
                },
                child: stationNearby(
                  name: data["NearEnough"]?[0]["Name"],
                  line: lineNumbersN,
                ),
              ),
              //Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  print("NEAR ENOUGH TRIAL69 ${coreTransferStationsDictN}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => stopInfoScreen(
                            stationDict: coreTransferStationsDictN,
                          ),
                    ),
                  );
                },
                child: stationNearby(
                  name: data["Near"]?[0]["Name"],
                  line: lineNumbersNE,
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NEAR YOU",
                style: TextStyle(
                  color: const Color.fromARGB(255, 109, 109, 109),
                  fontSize: 16.sp, //processedFontheight(context),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),

              Skeletonizer(
                //theme: SkeletonizerTheme.dark,
                //enableShimmer: true,
                //enableSwitchAnimation: true,
                child: ListTile(
                  title: Text('Item numas title'),
                  subtitle: const Text('Subtitle here'),
                  trailing: const Icon(Icons.ac_unit),
                ),
                // ListTile(
                //   title: Text('Bhikaji Cama Place'),
                //   subtitle: const Text('Dwarka Mor'),
                //   trailing: const Icon(Icons.ac_unit, size: 20),
                // ),
              ),
            ],
          );
          // return Container(
          //   padding: EdgeInsets.all(10),
          //   //height: 10, width: 10,
          //   //color: Colors.greenAccent,
          //   child: Center(
          //     child: RichText(
          //       text: TextSpan(
          //         children: [
          //           TextSpan(
          //             text: "Fetching nearby ",
          //             style: TextStyle(
          //               color: const Color.fromARGB(255, 161, 161, 161),
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           TextSpan(
          //             text: "stations ",
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),

          //           WidgetSpan(
          //             child: Icon(Icons.location_on, color: Colors.white),
          //           ),
          //           TextSpan(
          //             text: " just a",
          //             style: TextStyle(
          //               color: const Color.fromARGB(255, 161, 161, 161),
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           TextSpan(
          //             text: " moment ",
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           WidgetSpan(
          //             child: Icon(Icons.punch_clock, color: Colors.white),
          //           ),
          //           TextSpan(
          //             text: " check GPS if not.",
          //             style: TextStyle(
          //               color: const Color.fromARGB(255, 161, 161, 161),
          //               fontSize: 24,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           //WidgetSpan(child: cupertinoprogressindicator),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
        }

        //return Column(children: [stationNearby(name: data["Near"]![0])]);
      },
    ),
    // GestureDetector(
    //   onTap: () {},
    //   child: stationNearby(name: "Bhikaji Cama Place"),
    // ),
    // stationNearby(name: "South Extension"),
    //Geolocatorservice(), //HERE TEMPRORY TEST
  );
}

ticketAndExit(context) {
  // chat gpt
  return Container(
    width: double.infinity,
    height: 60.h, //processedHeight(context, 0.1, 50, 70),
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
              //borderRadius: BorderRadius.all(Radius.circular(5)),
              //border: Border.all(color: AppColors.divider),
              //color: const Color.fromARGB(255, 17, 17, 17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final whatsappUrl = Uri.parse(
                        'https://wa.me/+919650855800?text=Hi',
                      ); //add ?text=hi
                      await launchUrl(whatsappUrl);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.tickets,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => mapMetroScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.map, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          width: 5.w,
          // height: 50,
          // child: VerticalDivider(color: const Color.fromARGB(255, 35, 35, 35)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            child: GestureDetector(
              behavior:
                  HitTestBehavior
                      .opaque, // to make sure that when tapped on white space the button is tapped
              onTap: () {
                //TEMPROARY
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => stationSearchScreen(),
                  ),
                );
              },
              child: Center(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 5, 0),
                      child: Text(
                        "Stop",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 244, 244, 244),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'poppins',
                        color: Color.fromARGB(255, 194, 194, 194),
                        fontWeight: FontWeight.w500,
                      ),
                      child: AnimatedTextKit(
                        //pause = const Duration(milliseconds: 1000),
                        repeatForever: true,
                        animatedTexts: [
                          RotateAnimatedText('Information'),
                          RotateAnimatedText('Exit Gates'),
                          RotateAnimatedText('Schedule'),
                          RotateAnimatedText('Status'),
                        ],
                        onTap: () {
                          HitTestBehavior.opaque;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => stationSearchScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Container(
        //   width: 1,
        //   height: 50,
        //   color: const Color.fromARGB(255, 35, 35, 35),
        //   margin: EdgeInsets.symmetric(horizontal: 10),
        // ),
      ],
    ),
  );
}

// appFooter() {
//   return
// }

// class topHeader extends StatefulWidget {
//   //CHECK IF STATEFULL WIDGET IS NEEDED HERE
//   const topHeader({super.key});

//   @override
//   State<topHeader> createState() => _topHeaderState();
// }

// class _topHeaderState extends State<topHeader>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   bool get wantKeepAlive => true;
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       //height: processedHeight(context, 0.45, 300, 400),
//       // height:
//       //     MediaQuery.of(context).size.height *
//       //     0.4, //this is genius idk how i did this but why not, height is equal to width of screen
//       //width: double.infinity,
//       //margin: EdgeInsets.all(0),
//       // height:
//       //     420, //right now the hrigh of container is hard coded make by mkaing it expanded
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(0),
//           bottomRight: Radius.circular(0),
//         ),
//         image: DecorationImage(
//           image: const AssetImage('assets/Image/carfooter.jpg'),
//           fit: BoxFit.cover,
//         ),
//       ),

//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             margin: EdgeInsets.all(20),
//             child: Text(
//               "Delhi\nUnderground",
//               textAlign: TextAlign.right,
//               style: TextStyle(
//                 color: const Color.fromARGB(183, 255, 255, 255),
//                 //color: const Color.fromARGB(255, 61, 61, 61),
//                 height: 1,
//                 fontSize: 30,
//                 fontFamily: 'Poppins',
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

appFooter(context) {
  return Container(
    width: double.infinity,
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
      //color: const Color.fromARGB(255, 22, 22, 22),
      // gradient: LinearGradient(
      //   begin: Alignment.topCenter,
      //   end: Alignment.bottomCenter,
      //   colors: [
      //     Color.fromARGB(255, 45, 237, 255),
      //     Color.fromARGB(255, 45, 237, 255),
      //     // Color.fromARGB(121, 45, 237, 255),
      //     // Color(0xFF0D0D0D),
      //   ],
      // ),
      image: DecorationImage(
        image: AssetImage('assets/Image/carfooter.jpg'),
        fit: BoxFit.cover,
      ),
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Padding(padding: const EdgeInsets.all(8.0), child: InfoBar()),
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "Delhi\nUnderground",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              //color: const Color.fromARGB(255, 61, 61, 61),
              height: 1.h,
              fontSize: 30.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        // Spacer(),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     //Spacer(),
        //     GestureDetector(
        //       behavior: HitTestBehavior.opaque,
        //       onTap: () async {
        //         final whatsappUrl = Uri.parse(
        //           'https://wa.me/+919650855800?text=Hi',
        //         ); //add ?text=hi
        //         await launchUrl(whatsappUrl);
        //       },
        //       child: LiquidGlass(
        //         blur: 5,
        //         shape: LiquidRoundedSuperellipse(
        //           borderRadius: Radius.circular(10),
        //         ),
        //         settings: const LiquidGlassSettings(
        //           thickness: 10,
        //           glassColor: Color(0x1AFFFFFF), // A subtle white tint
        //           lightIntensity: 1.5,
        //           blend: 40,
        //           //outlineIntensity: 0.5,
        //         ),
        //         child: Container(
        //           padding: EdgeInsets.all(20),
        //           child: Text(
        //             "buy tickets",
        //             textAlign: TextAlign.left,
        //             style: TextStyle(
        //               color: const Color.fromARGB(255, 175, 175, 175),
        //               //color: const Color.fromARGB(255, 61, 61, 61),
        //               height: 1.h,
        //               fontSize: 16.sp,
        //               fontFamily: 'Poppins',
        //               fontWeight: FontWeight.w500,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: 5.w),
        //   ],
        // ),

        // SizedBox(height: 5),
        // Align(
        //   alignment: Alignment.topRight, // ⬅️ change this to desired side
        //   child: InfoBar(),
        // ),
        //SizedBox(height: 5),
      ],
    ),
  );
}

// double processedHeight(context, factorMax, minSize, prefferedHeight) {
//   //not working in split view, solve that bug
//   try {
//     print("Factor Max is $factorMax");
//     double finalHeight;
//     double height =
//         MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         MediaQuery.of(context).padding.bottom;
//     double width = MediaQuery.of(context).size.width;
//     print("HEIGHT IS $height");
//     print("WIDTH IS $width ");
//     double maxHeight = height * factorMax;
//     if (maxHeight == double.infinity || maxHeight.isNaN) {
//       maxHeight = prefferedHeight; // or some other default value
//     }
//     double minHeight = minSize.toDouble();
//     if (height < 700) {
//       //checks if phone multiview or normal screen

//       finalHeight =
//           maxHeight
//               .clamp(
//                 minHeight,
//                 height,
//               ) //bit of scrolling is inevitbale, so let it be
//               .toDouble(); //SOLVED: right now it has a bit of empty space at the bottom on some screens that are large, make it so that everyscreen has height derieved from screen height and preferred heigth is taken only when that cant be applied
//       print("FINAL HEIGHT IS $finalHeight");
//     } else {
//       print("using preffered height");
//       finalHeight = maxHeight = height * factorMax;
//     }

//     return finalHeight;
//   } catch (e) {
//     print("Error processing height: $e ");
//     return prefferedHeight.toDouble();
//   }
// }

// double processedFontheight(context) {
//   double width = MediaQuery.of(context).size.width;
//   if (width < 600) {
//     print("18");
//     return 18;
//   }
//   if (width >= 600) {
//     print("22");
//     return 22;
//   } else {
//     print("18");
//     return 18;
//   }
// }
