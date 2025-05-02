import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.black, body: searchBody(context)),
    );
  }
}

searchBody(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Column(children: [backBox(context), searchCluster()]),
  );
}

backBox(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: GestureDetector(
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
            "Back",
            style: TextStyle(
              color: const Color.fromARGB(255, 47, 130, 255),
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

searchCluster() {
  return Stack(
    alignment: Alignment.center,
    children: [searchBox(), flipCircle()],
  );
}

searchBox() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 8, 8, 8),
      border: Border.all(
        color: const Color.fromARGB(255, 234, 234, 234),
        width: 3,
      ),
      borderRadius: BorderRadius.circular(40),
    ),
    width: double.infinity,
    height: 130,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    ),
  );
}

flipCircle() {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 26, 26, 26),
      borderRadius: BorderRadius.circular(40),
    ),
    width: 40,
    height: 40,
    child: Icon(
      CupertinoIcons.chevron_up_chevron_down,
      color: const Color.fromARGB(255, 234, 234, 234),
    ),
  );
}
