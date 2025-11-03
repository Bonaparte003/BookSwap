import 'package:flutter/material.dart';

Widget bottomNavigation(BuildContext context) {
  return ClipRRect(
    // borderRadius: const BorderRadius.only(
    //   topLeft: Radius.circular(10),
    //   topRight: Radius.circular(10),
    // ),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.09,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.home, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.library_books, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.message, color: Colors.white)),
        ],
      ),
    ),
  );
}