import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StationTimesWidget extends StatelessWidget {
  final stationCode;
  const StationTimesWidget({super.key, required this.stationCode});

  Future<Map<String, dynamic>> _loadStationData() async {
    final String response = await rootBundle.loadString(
      'assets/Map/stationOpenClose.json',
    );
    return jsonDecode(response);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadStationData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final data = snapshot.data!;
        final mpk = data['$stationCode'];

        return Container(
          padding: EdgeInsets.all(2),
          child: Row(
            children: [
              Text(
                "Opens from ${mpk['opens']} until ${mpk['closes']}",
                style: TextStyle(
                  color: const Color.fromARGB(255, 130, 130, 130),
                  fontWeight: FontWeight.w500,
                ),
              ),
              //const SizedBox(height: 20),
              // for (var entry in data.entries)
              //   Card(
              //     child: ListTile(
              //       title: Text(entry.key),
              //       subtitle: Text(
              //         "Opens: ${entry.value['opens']} | Closes: ${entry.value['closes']}",
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}
