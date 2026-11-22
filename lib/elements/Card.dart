import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MetroCardScreen extends StatefulWidget {
  const MetroCardScreen({super.key});

  @override
  State<MetroCardScreen> createState() => _MetroCardScreenState();
}

class _MetroCardScreenState extends State<MetroCardScreen> {
  bool _cardDetected = false;

  void _tapToReadCard() {
    setState(() {
      _cardDetected = true;
    });
  }

  void _retryCardScan() {
    setState(() {
      _cardDetected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: const Color(0xFFF0F0F0),
        ),
        title: Text(
          'My Card',
          style: TextStyle(
            color: const Color(0xFFF0F0F0),
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Requirements',
                style: TextStyle(
                  color: const Color(0xFFF0F0F0),
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 22.h),
              _requirementTile(
                leading: Image.asset(
                  'assets/Image/NFClogo.png',
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
                title: 'NFC',
                subtitle: 'Turn on NFC in your phone settings',
              ),
              SizedBox(height: 10.h),
              _requirementTile(
                leading: Image.asset(
                  'assets/Image/RupayLogo.webp',
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
                title: 'NCMC card',
                subtitle: 'Use a supported National Common Mobility Card',
              ),

              SizedBox(height: 10.h),

              Center(child: _buildPhoneCard(context)),
              if (_cardDetected) ...[
                SizedBox(height: 10.h),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: _retryCardScan,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFF0F0F0),
                      side: const BorderSide(color: Color(0xFF3A3A3A)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      'Retry',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneCard(BuildContext context) {
    return InkWell(
      onTap: _cardDetected ? null : _tapToReadCard,
      splashColor: const Color.fromARGB(0, 255, 255, 255),
      // borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 200.h,
        width: 200.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 50.h),
        decoration: BoxDecoration(
          color:
              _cardDetected
                  ? const Color.fromARGB(255, 29, 255, 157)
                  : Colors.white,
          borderRadius: BorderRadius.circular(10000),
          border: Border.all(
            color:
                _cardDetected
                    ? const Color(0xFF10B981)
                    : const Color(0xFF3A3A3A),
            width: 1,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 450),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.88, end: 1).animate(animation),
                child: child,
              ),
            );
          },
          child:
              _cardDetected
                  ? Column(
                    key: const ValueKey('card_balance'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Card Balance',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '₹285.50',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'Poppins',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                  : Image.asset(
                    'assets/Image/tapCard.png',
                    key: const ValueKey('tap_card_logo'),
                    width: 100.sp,
                    fit: BoxFit.contain,
                  ),
        ),
      ),
    );
  }

  Widget _requirementTile({
    required Widget leading,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        // borderRadius: BorderRadius.circular(14.r),
        // border: Border.all(color: const Color(0xFF2C2C2C)),
      ),
      child: Row(
        children: [
          Container(
            // width: 42.w,
            // height: 42.w,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              // borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: leading,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFFF0F0F0),
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFFB0B0B0),
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
