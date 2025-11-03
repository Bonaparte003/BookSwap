import 'package:flutter/material.dart';
import 'package:bookswap/routes/routes.dart';

AppBar topNavigation(BuildContext context) {
  return AppBar(
    toolbarHeight: 80,
    actionsPadding: EdgeInsets.all(10),
    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    leading: IconButton(
      onPressed: () async {
        if (context.mounted) {
          Navigator.pushNamed(context, AppRoutes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error logging out'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      icon: Icon(Icons.menu_book, color: Colors.white),
    ),
    actions: [
      Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image(
            image: AssetImage('assets/images/books.jpg'),
            width: 30,
            height: 30,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  );
}