import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class stopInfoScreen extends StatefulWidget {
  const stopInfoScreen({super.key});

  @override
  State<stopInfoScreen> createState() => _stopInfoScreenState();
}

class _stopInfoScreenState extends State<stopInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: stationCluster(context),
    );
  }
}

stationCluster(context) {
  return Container(
    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: Column(
      children: [
        topNavBar(context),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              stationLineMarker(),
              SizedBox(height: 40),
              closeAndOpeningTime(),
              stationStatus(),
              SizedBox(height: 5),
              toAndFromBlock(),
              SizedBox(height: 40),
              exitBlock(),
              SizedBox(height: 40),
              scheduleBlock(),
              SizedBox(height: 40),
              ammenitiesBlock(),
              SizedBox(height: 40),
              companyFooter(),
            ],
          ),
        ),
      ],
    ),
  );
}

topNavBar(context) {
  return Container(
    color: const Color.fromARGB(255, 8, 8, 8),
    padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
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
                "Done",
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
        //
      ],
    ),
  ); //////////////
}

stationLineMarker() {
  return Container(
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 164, 164, 164)),
    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
    //height: 200,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hauz Khas",
          style: TextStyle(
            color: const Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        Text(
          "हौज़ खास",
          style: TextStyle(
            color: const Color.fromARGB(255, 187, 187, 187),
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              SizedBox(width: 5),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

closeAndOpeningTime() {
  return Container(
    padding: EdgeInsets.all(5),
    child: Text(
      "Opens from 06:00 until 23:00",
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
    ),
  );
}

stationStatus() {
  return Container(
    height: 80,
    width: double.infinity,

    //color: Colors.teal,
    child: Row(
      children: [
        Container(
          color: const Color.fromARGB(255, 25, 25, 25),
          width: 90,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "QUIET",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                "crowd",
                style: TextStyle(
                  color: const Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 25, 25, 25),
            width: 90,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "NO DISRUPTION",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward, color: Colors.green, size: 15),
                  ],
                ),
                Text(
                  "check details",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

toAndFromBlock() {
  return Container(
    height: 80,
    width: double.infinity,
    //color: Colors.teal,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 25, 25, 25),
            width: 90,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "GO TO",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.blueAccent,
                      size: 15,
                    ),
                  ],
                ),
                Text(
                  "this station",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: const Color.fromARGB(255, 25, 25, 25),
            width: 90,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "GET FROM",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.blueAccent,
                      size: 15,
                    ),
                  ],
                ),
                Text(
                  "this station",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 108, 108, 108),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

exitBlock() {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "EXIT",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              "Gate 1",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "GAIL Office",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        //SizedBox(height: 2),
        Row(
          children: [
            Text(
              "Gate 2",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "Palika bhawan",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        //SizedBox(height: 2),
        Row(
          children: [
            Text(
              "Gate 3",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "EIL Office",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Gate 4",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "Sarojni Nagar",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Image/mapimg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: [
              Text(
                "VISULIZE ON MAP",
                style: TextStyle(
                  color: const Color.fromARGB(255, 179, 179, 179),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.chevron_right,
                color: const Color.fromARGB(255, 179, 179, 179),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

scheduleBlock() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "SCHEDULE",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon(
            //   Icons.forward_rounded,
            //   color: const Color.fromARGB(255, 122, 122, 122),
            // ),
            Text(
              "Majlis Park",
              style: TextStyle(
                color: const Color.fromARGB(255, 209, 209, 209),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "10 min",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                //fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon(
            //   Icons.forward_rounded,
            //   color: const Color.fromARGB(255, 122, 122, 122),
            // ),
            Text(
              "Mayur vihar",
              style: TextStyle(
                color: const Color.fromARGB(255, 212, 212, 212),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Text(
              "10 min",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

ammenitiesBlock() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "AMMENITIES",
          style: TextStyle(
            color: const Color.fromARGB(255, 109, 109, 109),
            fontSize: 16, //processedFontheight(context),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              "Washroom",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "Avilable",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
              ),
            ),
            // SizedBox(width: 10),
            // Icon(
            //   Icons.wash,
            //   color: const Color.fromARGB(255, 191, 191, 191),
            //   size: 15,
            // ),
          ],
        ),
        Row(
          children: [
            Text(
              "Foodcourt",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              " Avilable",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
              ),
            ),

            // SizedBox(width: 10),
            // Icon(
            //   Icons.food_bank,
            //   color: const Color.fromARGB(255, 191, 191, 191),
            //   size: 15,
            // ),
          ],
        ),
        Row(
          children: [
            Text(
              "Wifi",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              "Unavilable",
              style: TextStyle(
                color: const Color.fromARGB(255, 191, 191, 191),
                fontSize: 16,
              ),
            ),
            // SizedBox(width: 10),
            // Icon(
            //   Icons.wifi,
            //   color: const Color.fromARGB(255, 191, 191, 191),
            //   size: 15,
            // ),
          ],
        ),
      ],
    ),
  );
}

companyFooter() {
  return Container(
    decoration: BoxDecoration(
      //color: const Color.fromARGB(255, 11, 11, 11),
      //borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    width: double.infinity,
    height: 100,
    //color: const Color.fromARGB(255, 57, 57, 57),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "DELHI\nUNDERGROUND",
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1,
            color: const Color.fromARGB(255, 90, 90, 90),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        // Text(
        //   "From New Delhi",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: Colors.grey,
        //     fontWeight: FontWeight.w300,
        //     fontSize: 12,
        //   ),
        // ),
      ],
    ),
  );
}
