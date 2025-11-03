import 'package:flutter/material.dart';
import 'package:bookswap/Layouts/top-navigation.dart';
import 'package:bookswap/Layouts/bottom-navigation.dart';
import 'package:bookswap/Layouts/browse-layout.dart';
import 'package:bookswap/routes/routes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 230, 193), // Set Scaffold background to match
      appBar: topNavigation(context),
      body: Stack(
        children: [
          BrowseLayout(),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addBook);
              },
              child: Icon(Icons.add, color:  const Color.fromARGB(255, 220, 187, 133), size: 30,),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigation(context),
    );
  }
}