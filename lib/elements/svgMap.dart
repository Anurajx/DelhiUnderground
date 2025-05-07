import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgMap extends StatelessWidget {
  const SvgMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: InteractiveViewer(
        maxScale: 20,
        minScale: 1,
        panEnabled: true,
        child: AspectRatio(
          aspectRatio: 1.317,
          child: SvgPicture.asset(
            "assets/Map/svgMap1.svg",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
