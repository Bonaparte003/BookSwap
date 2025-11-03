import 'package:flutter/material.dart';

class BrowseLayout extends StatefulWidget {
  const BrowseLayout({super.key});

  @override
  State<BrowseLayout> createState() => _BrowseLayoutState();
}

class _BrowseLayoutState extends State<BrowseLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Text('Browse'),
        ],
      ),
    );
  }
}