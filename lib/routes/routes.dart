import 'package:flutter/material.dart';
import 'package:bookswap/Screens/splashscreen.dart';
import 'package:bookswap/Screens/login.dart';
import 'package:bookswap/Screens/signup.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
}

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const Splashscreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => Login());
    case AppRoutes.signup:
      return MaterialPageRoute(builder: (_) => Signup());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

