import 'package:flutter/material.dart';

// -------------------- LINE COLORS --------------------
Color getLineColor(int lineNumber) {
  switch (lineNumber) {
    case 1:
      return const Color.fromARGB(255, 209, 52, 56); // Red
    case 2:
      return const Color.fromARGB(255, 200, 155, 0); // Yellow
    case 3:
      return const Color.fromARGB(255, 0, 122, 204); // Blue main
    case 4:
      return const Color.fromARGB(255, 0, 142, 224); // Blue branch
    case 5:
      return const Color.fromARGB(255, 0, 168, 107); // Green
    case 6:
      return const Color.fromARGB(255, 125, 68, 157); // Violet
    case 7:
      return const Color.fromARGB(255, 219, 112, 147); // Pink
    case 8:
      return const Color.fromARGB(255, 170, 0, 119); // Magenta
    case 9:
      return const Color.fromARGB(255, 130, 130, 130); // Grey
    case 10:
      return const Color.fromARGB(255, 255, 114, 12); // Airport
    case 15:
      return const Color.fromARGB(255, 0, 185, 235); // Rapid Metro
    case 20:
      return const Color.fromARGB(255, 0, 185, 235); // Aqua Line
    default:
      return Colors.grey;
  }
}

// -------------------- MODEL --------------------
class LineStatusInfo {
  final int lineNumber;
  final String lineName;
  final bool hasDisruption;
  final String? disruptionMessage;

  const LineStatusInfo({
    required this.lineNumber,
    required this.lineName,
    this.hasDisruption = false,
    this.disruptionMessage,
  });

  Color get color => getLineColor(lineNumber);
}

// -------------------- FULL SCREEN WIDGET --------------------
class LineStatusScreen extends StatefulWidget {
  final List<LineStatusInfo>? statuses;

  const LineStatusScreen({super.key, this.statuses});

  @override
  State<LineStatusScreen> createState() => _LineStatusScreenState();
}

class _LineStatusScreenState extends State<LineStatusScreen> {
  static const Color _screenBg = Colors.black;
  static const Color _headerText = Color.fromARGB(255, 109, 109, 109);

  late List<LineStatusInfo> _lineStatuses;

  @override
  void initState() {
    super.initState();
    _lineStatuses = widget.statuses ?? _defaultLines();
  }

  List<LineStatusInfo> _defaultLines() {
    return const [
      LineStatusInfo(lineNumber: 1, lineName: "Red Line"),
      LineStatusInfo(lineNumber: 2, lineName: "Yellow Line"),
      LineStatusInfo(lineNumber: 3, lineName: "Blue Line"),
      LineStatusInfo(lineNumber: 4, lineName: "Blue Branch"),
      LineStatusInfo(lineNumber: 5, lineName: "Green Line"),
      LineStatusInfo(lineNumber: 6, lineName: "Violet Line"),
      LineStatusInfo(lineNumber: 7, lineName: "Pink Line"),
      LineStatusInfo(lineNumber: 8, lineName: "Magenta Line"),
      LineStatusInfo(lineNumber: 9, lineName: "Grey Line"),
      LineStatusInfo(lineNumber: 10, lineName: "Airport Express"),
      LineStatusInfo(lineNumber: 15, lineName: "Rapid Metro"),
      LineStatusInfo(lineNumber: 20, lineName: "Aqua Line"),
    ];
  }

  Widget _buildLineRow(LineStatusInfo info) {
    final bool isDisrupted = info.hasDisruption;
    final String statusText =
        isDisrupted
            ? (info.disruptionMessage != null &&
                    info.disruptionMessage!.isNotEmpty
                ? "Disruption · ${info.disruptionMessage!.toLowerCase()}"
                : "Disruption")
            : "Normal Service";

    final Color tonedDownColor =
        Color.lerp(info.color, const Color(0xFF161616), 0.72)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tonedDownColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top-left saturated tab holding only the line number & name width
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: info.color,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(4.0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   "L${info.lineNumber}",
                //   style: TextStyle(
                //     color: Colors.white.withValues(alpha: 0.8),
                //     fontSize: 12.0,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // const SizedBox(width: 8.0),
                Text(
                  info.lineName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Status row in the toned-down lower section
          Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDisrupted
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF22C55E),
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    statusText,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color:
                          isDisrupted
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.9),
                      fontSize: 14.0,
                      fontWeight:
                          isDisrupted ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      appBar: AppBar(
        backgroundColor: _screenBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 18.0,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: const Text(
          "LINE STATUS",
          style: TextStyle(
            color: _headerText,
            fontSize: 16.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 24.0),
          children: _lineStatuses.map(_buildLineRow).toList(),
        ),
      ),
    );
  }
}
