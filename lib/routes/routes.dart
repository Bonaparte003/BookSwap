import 'package:flutter/material.dart';
import 'package:bookswap/Firebase/auth_wrapper.dart';
import 'package:bookswap/Screens/login.dart';
import 'package:bookswap/Screens/signup.dart';
import 'package:bookswap/Screens/home.dart';
import 'package:bookswap/Screens/add_book.dart';
import 'package:bookswap/Screens/chat_detail.dart';
import 'package:bookswap/Models/chat.dart';
import 'package:bookswap/Models/book.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String addBook = '/add-book';
  static const String chatDetail = '/chat-detail';
}

Route generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const AuthWrapper());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const Login());
    case AppRoutes.signup:
      return MaterialPageRoute(builder: (_) => const Signup());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const Home());
    case AppRoutes.addBook:
      final book = settings.arguments as Book?;
      return MaterialPageRoute(builder: (_) => AddBook(book: book));
    case AppRoutes.chatDetail:
      final chat = settings.arguments as Chat;
      return MaterialPageRoute(
        builder: (_) => ChatDetailScreen(chat: chat),
      );
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

