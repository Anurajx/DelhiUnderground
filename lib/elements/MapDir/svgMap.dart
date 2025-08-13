import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgMap extends StatefulWidget {
  const SvgMap({super.key});

  @override
  State<SvgMap> createState() => _SvgMapState();
}

class _SvgMapState extends State<SvgMap> {
  final TransformationController _controller = TransformationController();

  @override
  void initState() {
    super.initState();
    // Initial zoom and pan (customize these)
    _controller.value =
        Matrix4.identity()
          ..scale(3.0)
          ..translate(-140.0, -115.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _controller,
            maxScale: 20,
            minScale: 1,
            panEnabled: true,
            child: SvgPicture.asset(
              "assets/Map/svgMap1.svg",
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}


// Container(
//       decoration: const BoxDecoration(color: Color.fromARGB(255, 24, 24, 27)),
//       child: InteractiveViewer(
//         transformationController: _controller,
//         maxScale: 20,
//         minScale: 1,
//         panEnabled: true,
//         child: SvgPicture.asset("assets/Map/svgMap1.svg"),
//       ),
//     );