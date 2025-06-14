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
    padding: EdgeInsets.fromLTRB(20, 20, 10, 5),
    child: Column(children: [topNavBar(context), stationLineMarker()]),
  );
}

topNavBar(context) {
  return Container(
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
      ],
    ),
  );
}

stationLineMarker() {
  return Container(
    //decoration: BoxDecoration(color: const Color.fromARGB(255, 164, 164, 164)),
    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
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
          "Central Delhi",
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
