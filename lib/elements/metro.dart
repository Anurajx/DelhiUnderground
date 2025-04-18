import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'map.dart';
import 'package:marquee/marquee.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            MapScreen(), //add the bottom sheet size so that the map can be seen
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.05,
              maxChildSize: 0.9,
              snap: true,
              snapSizes: [0.4],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 24, 24, 24),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    color: const Color.fromARGB(
                                      255,
                                      35,
                                      35,
                                      35,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [searchBar(), suggestions()],
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
        ),
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
      decoration: const BoxDecoration(color: Color.fromARGB(255, 8, 8, 8)),
      width: double.infinity,
      height: 40,
      child: Marquee(
        //adding marquee effect to text with help of the package
        text:
            "SLIGHT DELAY ON PINK LINE EXPECTED 5 MINS.", //Hard coded text for now, will add an feature to dyanmically change it
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

searchBar() {
  //search bar widget when tapped a new screen opens where user can enter departure and concorse
  return Container(
    padding: const EdgeInsets.all(5),
    width: double.infinity,
    height: 45,
    decoration: BoxDecoration(color: const Color.fromARGB(255, 234, 234, 234)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Where to',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: const Color.fromARGB(201, 15, 15, 15),
          ),
        ),
        Icon(CupertinoIcons.search),
      ],
    ),
  );
}

suggestions() {
  return Container(
    margin: const EdgeInsets.all(5),
    width: double.infinity,
    height: 90,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // ADD APP LOGIC HERE FOR NEXT SCREEN
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rajouri Garden',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(CupertinoIcons.arrow_right, color: Colors.white),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            //ADD APP LOGIC HERE FOR NEXT SCREEN
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nehru Place',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(CupertinoIcons.arrow_right, color: Colors.white),
            ],
          ),
        ),
      ],
    ),
  );
}
