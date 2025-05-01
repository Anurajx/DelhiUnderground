import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'map.dart';
import 'package:marquee/marquee.dart';
import 'package:vibration/vibration.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapScreen(), //add the bottom sheet size so that the map can be seen
          DraggableScrollableSheet(
            //make this a seprate function so that it can be reused for station info screen
            initialChildSize: 0.4,
            minChildSize: 0.12,
            //maxChildSize: 0.9,
            snap: true,
            snapSizes: [0.4],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 8, 8),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  searchBar(),
                                  suggestions(),
                                  Divider(
                                    thickness: 1,

                                    color: const Color.fromARGB(
                                      255,
                                      35,
                                      35,
                                      35,
                                    ),
                                  ),
                                  nearYou(),
                                  Divider(
                                    thickness: 1,
                                    color: const Color.fromARGB(
                                      255,
                                      35,
                                      35,
                                      35,
                                    ),
                                  ),
                                  ticketAndExit(),
                                  appFooter(),
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
  return GestureDetector(
    onTap: () {},
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
              SizedBox(
                width: 5,
              ), // adding to create a bit of space between line indicatot and text
              Container(
                width: 5,
                height: 15,
                color: const Color(
                  0xFF0072BC,
                ), //blue line color will make it dynamic later
              ), //container for line indication
              Container(
                width: 5,
                height: 15,
                color: const Color(
                  0xFFFC8EAC,
                ), //blue line color will make it dynamic later
              ), //container for line indication
              Spacer(), // spacer to make sure spce between text and arrow icon
              Icon(
                CupertinoIcons.arrow_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
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
                'Rajiv Chowk ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                width: 5,
              ), // adding to create a bit of space between line indicatot and text
              Container(
                width: 5,
                height: 15,
                color: const Color(
                  0xFF0072BC,
                ), //blue line color will make it dynamic later
              ),
              Container(
                width: 5,
                height: 15,
                color: const Color(
                  0xFFF47B20,
                ), //blue line color will make it dynamic later
              ),
              Container(
                width: 5,
                height: 15,
                color: const Color(
                  0xFFFFD300,
                ), //blue line color will make it dynamic later
              ),
              Spacer(),
              Icon(
                CupertinoIcons.arrow_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
            ],
          ),
        ),
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
        GestureDetector(
          onTap: () {
            //ADD APP LOGIC HERE FOR NEXT SCREEN
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RK Puram",
                style: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
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
                "Bhikaji Cama Place",
                style: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
            ],
          ),
        ),
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

appFooter() {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.all(0),
    height: 420,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/Image/footer.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "New Delhi",
            style: TextStyle(
              color: const Color.fromARGB(255, 216, 216, 216),
              fontSize: 40,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
