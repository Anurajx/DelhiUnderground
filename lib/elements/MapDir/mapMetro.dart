import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class mapMetroScreen extends StatefulWidget {
  const mapMetroScreen({super.key});

  @override
  State<mapMetroScreen> createState() => _mapMetroScreenState();
}

class _mapMetroScreenState extends State<mapMetroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 8, 8),
      body: mapScreenCluster(context),
    );
  }
}

mapScreenCluster(context) {
  return SafeArea(child: Stack(children: [metroMap(), topNavBar(context)]));
}

topNavBar(context) {
  return Container(
    color: const Color.fromARGB(255, 0, 0, 0),
    // decoration: BoxDecoration(
    //   color: Colors.black,
    //   boxShadow: [
    //     BoxShadow(
    //       color: const Color.fromARGB(29, 255, 255, 255),
    //       blurRadius: 50,
    //       offset: Offset(0, 25),
    //     ),
    //   ],
    // ),
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
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Text(
          "From DMRC  ",
          style: TextStyle(
            color: const Color.fromARGB(255, 177, 177, 177),
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      ],
    ),
  ); //////////////
}

// topNavBlur(context) {
//   return BackdropFilter(
//     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//     child: topNavBar(context),
//   );
// }

metroMap() {
  return Container(
    height: double.infinity,
    width: double.infinity,

    child: InteractiveViewer(
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1,
      maxScale: 20,
      child: Center(
        child: Image.asset(
          "assets/Map/DelhiMetroMap0.png",
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    ),
  );
}
