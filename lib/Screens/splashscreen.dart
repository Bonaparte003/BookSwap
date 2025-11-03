import 'package:flutter/material.dart';
import 'package:bookswap/routes/routes.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset('assets/images/books.jpg', fit: BoxFit.cover),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [const Color.fromARGB(255, 228, 80, 0).withOpacity(0.5), Colors.black.withOpacity(1)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 100, color: Colors.white),
                      SizedBox(height: 20,),
                      Text('BookSwap', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
                      Text('Swap your books with your friends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(155, 255, 255, 255)),),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, AppRoutes.login);
                }, 
                child: Text('Get Started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 231, 101, 1)),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}