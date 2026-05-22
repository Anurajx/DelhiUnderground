import 'package:flutter/material.dart';
import 'package:metroapp/elements/RouteDir/route_data_provider.dart';
import 'package:metroapp/elements/ServicesDir/data_provider.dart';
import 'package:provider/provider.dart';

class RouteScreen extends StatefulWidget {
  final Map<String, dynamic> coreTransferStationsDict;
  const RouteScreen({super.key, required this.coreTransferStationsDict});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("CORE STATIONS: ${widget.coreTransferStationsDict}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = context.read<DataProvider>();
      debugPrint("CORE STATIONS: ${widget.coreTransferStationsDict}");
      dataProvider.updateJustData(widget.coreTransferStationsDict);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: RouteScreenNew(
          coreTransferStationsDict: widget.coreTransferStationsDict,
        ),
      ),
    );
  }
}
