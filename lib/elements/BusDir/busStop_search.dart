import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:metroapp/elements/StationDir/stop_info.dart'
    show MetroDbService;
import 'package:metroapp/elements/BusDir/busStop_info.dart';
import 'package:string_similarity/string_similarity.dart';

class BusStopSearchScreen extends StatefulWidget {
  const BusStopSearchScreen({super.key});

  @override
  State<BusStopSearchScreen> createState() => _BusStopSearchScreenState();
}

class _BusStopSearchScreenState extends State<BusStopSearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _busStops = [];
  List<Map<String, dynamic>> _filteredBusStops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusStops();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadBusStops() async {
    try {
      final db = await MetroDbService.getDatabase();
      final rows = await db.query(
        'bus_stop',
        columns: ['id', 'latitude', 'longitude', 'name'],
        orderBy: 'name COLLATE NOCASE ASC',
      );
      if (!mounted) return;
      setState(() {
        _busStops = rows;
        _filteredBusStops = rows;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Error loading bus stops from metro.db: $error');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterBusStops(String query) {
    final lowerQuery = query.trim().toLowerCase();
    setState(() {
      if (lowerQuery.isEmpty) {
        _filteredBusStops = _busStops;
        return;
      }

      final scored =
          _busStops
              .map((stop) {
                final name = stop['name']?.toString().toLowerCase() ?? '';
                final score = StringSimilarity.compareTwoStrings(
                  name,
                  lowerQuery,
                );
                return MapEntry(stop, score);
              })
              .where((entry) {
                final name = entry.key['name']?.toString().toLowerCase() ?? '';
                return entry.value > 0.45 || name.contains(lowerQuery);
              })
              .toList();

      scored.sort((a, b) => b.value.compareTo(a.value));
      _filteredBusStops = scored.map((entry) => entry.key).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.back,
                            color: const Color(0xFF4782FF),
                            size: 24.sp,
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: const Color(0xFF4782FF),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Bus Stops',
                style: TextStyle(
                  color: const Color(0xFFDCDCDC),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                height: 45.h,
                margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  // borderRadius: BorderRadius.circular(8.r),
                ),
                // padding: EdgeInsets.symmetric(horizontal: 15.w),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _filterBusStops,
                    textCapitalization: TextCapitalization.sentences,
                    cursorOpacityAnimates: true,
                    decoration: InputDecoration(
                      // Removed 'const' to allow dynamic .sp sizing
                      border: InputBorder.none,
                      hintText: 'Bus stop name',
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          81,
                          81,
                          81,
                        ), // Change this to your desired color (e.g., Color(0xFF9E9E9E))
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      // fillColor: Colors.white,
                      // iconColor: Colors.black,
                    ),
                    style: TextStyle(
                      color: const Color(0xFF0F0F0F),
                      fontSize: 18.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(color: Colors.white),
      );
    }
    if (_filteredBusStops.isEmpty) {
      return const Center(
        child: Text(
          'No bus stops found',
          style: TextStyle(
            color: Color(0xFFFF9191),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredBusStops.length,
      separatorBuilder:
          (_, _) => const Divider(color: Color(0xFF1B1B1B), height: 1),
      itemBuilder: (context, index) {
        final stop = _filteredBusStops[index];
        final stopId = stop['id'] as int;
        final name = stop['name']?.toString() ?? 'Bus stop';

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StopInfoScreen(stopId: stopId)),
            );
          },
          child: Container(
            height: 64.h,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFFF0F0F0),
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xFFB3B3B3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
