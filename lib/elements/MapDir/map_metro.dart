import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapMetroScreen extends StatefulWidget {
  const MapMetroScreen({super.key});

  @override
  State<MapMetroScreen> createState() => _MapMetroScreenState();
}

class _MapMetroScreenState extends State<MapMetroScreen> {
  String selectedOption = "Delhi Metro";
  bool isMapLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 8, 8),
      body: mapScreenCluster(context),
    );
  }

  Widget mapScreenCluster(BuildContext context) {
    return SafeArea(child: Stack(children: [metroMap(), topNavBar(context)]));
  }

  Widget topNavBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.back,
                      color: Color.fromARGB(255, 47, 130, 255),
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
              const Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedOption,
                  dropdownColor: const Color.fromARGB(255, 10, 10, 10),
                  icon: Icon(
                    CupertinoIcons.chevron_down,
                    size: 14.sp,
                    color: const Color.fromARGB(255, 245, 245, 245),
                  ),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 241, 240, 240),
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != selectedOption) {
                      setState(() {
                        selectedOption = newValue;
                        isMapLoaded =
                            false; // Reset loading state when switching maps
                      });
                    }
                  },
                  items:
                      <String>[
                        'Delhi Metro',
                        'Airport Express',
                        'RapidMetro',
                        'RRTS',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Progress bar displays until isMapLoaded is true
        if (!isMapLoaded)
          LinearProgressIndicator(
            minHeight: 1.h,
            backgroundColor: const Color.fromARGB(101, 47, 130, 255),
            color: const Color.fromARGB(255, 47, 130, 255),
            stopIndicatorColor: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          )
        else
          SizedBox(),
      ],
    );
  }

  Widget metroMap() {
    return SizedBox(
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
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                if (!isMapLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Delay setting state to true by 2 seconds to inspect the loader
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          isMapLoaded = true;
                        });
                      }
                    });
                  });
                }
                return child;
              }
              return child;
            },
          ),
        ),
      ),
    );
  }
}
