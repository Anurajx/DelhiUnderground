import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metroapp/elements/ServicesDir/data_Provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'elements/metro.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataProvider =
      DataProvider(); // UPDATES MOST RECENT SEARCHES FROM MEMORY
  await dataProvider.loadTransferDictFromPrefs();

  // Set global status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ChangeNotifierProvider<DataProvider>.value(
      value: dataProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // for an responsive design
      designSize: Size(411, 917), // Based on Samsung M33 5G
      minTextAdapt: true,
      useInheritedMediaQuery: true, // ✅ Ensure full media query inheritance
      builder: (context, child) {
        // had to use builder because the mediaquery was resulting to bugging of top status bar
        return MaterialApp(
          title: 'Metro App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            extensions: const [SkeletonizerConfigData.dark()],
            textTheme: TextTheme(
              bodyMedium: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w300,
              ),
            ),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color.fromARGB(255, 47, 130, 255),
              selectionColor: Color.fromARGB(150, 47, 130, 255),
              selectionHandleColor: Color.fromARGB(255, 47, 130, 255),
            ),
          ),
          home: AnnotatedRegion<SystemUiOverlayStyle>(
            // for top nav bar
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light,
            ),
            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 8, 8, 8),
              body: const SafeArea(child: Page1()),
            ),
          ),
          builder: (context, widget) {
            // BUILDER TO Apply textScaler override here safely
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              //if user has set font size to be big or small this resets it
              data: mediaQuery.copyWith(textScaler: TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
