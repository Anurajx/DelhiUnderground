import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class mapMetroScreen extends StatefulWidget {
  const mapMetroScreen({super.key});

  @override
  State<mapMetroScreen> createState() => _mapMetroScreenState();
}

class _mapMetroScreenState extends State<mapMetroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: mapScreenCluster(context),
    );
  }
}

mapScreenCluster(context) {
  return SafeArea(child: Stack(children: [metroMap(), topNavBar(context)]));
}

topNavBar(context) {
  return Container(
    padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
    child: LiquidGlass(
      //blur: 0.5,
      glassContainsChild: false,
      settings: const LiquidGlassSettings(
        thickness: 25,
        //outlineIntensity: 0.5,
        glassColor: Color.fromARGB(33, 255, 255, 255), // A subtle white tint
        lightIntensity: 2.5,
        blend: 40,
        ambientStrength: 20,
        //outlineIntensity: 0.5,
      ),
      shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(50)),
      child: Container(
        //color: Colors.black,
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
            Spacer(),
            Text(
              "Credit: Inat.fr  ",
              style: TextStyle(
                color: const Color.fromARGB(255, 177, 177, 177),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
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
      //constrained: false,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1,
      maxScale: 20,
      child: Center(
        child: Image.asset("assets/Map/DelhiMetroMap.png", fit: BoxFit.contain),
      ),
    ),
  );
}
