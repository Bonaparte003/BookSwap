// 
//Bookswap - main.dart
//
// This is the entry point of the BookSwap application.
// 
// app architecture:
// - State Management: Flutter Riverpod (ProviderScope wraps entire app)
// - Navigation: Named routes (see routes/routes.dart)
// - Authentication: Firebase Auth (handled by AuthWrapper)
// - Database: Cloud Firestore
// - Storage: Firebase Storage (for book covers and profile pictures)
// - Notifications: Local notifications (flutter_local_notifications)
// 
// flow:
// 1. Initialize Firebase
// 2. Initialize Notification Service
// 3. Wrap app in ProviderScope (for Riverpod state management)
// 4. MaterialApp uses named routes for navigation
// 5. AuthWrapper determines which screen to show based on auth state
// 
//

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/routes/routes.dart';
import 'package:bookswap/Services/notification_service.dart';

// Main entry point of the application
// 
// Initialization order:
// 1. Ensure Flutter bindings are initialized (required for async operations)
// 2. Initialize Firebase (database, auth, storage)
// 3. Initialize Notification Service (for local push notifications)
// 4. Run the app wrapped in ProviderScope (Riverpod state management)
void main() async {
  // Required for async operations before runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Firestore, Auth, Storage)
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized successfully');
    } else {
      debugPrint(' Firebase already initialized');
    }
  } catch (e, stackTrace) {
    // Firebase initialization failed
    debugPrint(' Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    debugPrint('Note: The google-services.json plugin may not have processed correctly.');
    debugPrint('Try: flutter clean, then flutter pub get, then full rebuild');
  }

  // Initialize local notification service (for push notifications)
  try {
    await NotificationService().initialize();
    debugPrint('Notification service initialized successfully');
  } catch (e) {
    debugPrint('Notification service initialization error: $e');
  }
  
  // Run the app wrapped in ProviderScope for Riverpod state management
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Root widget of the application
// 
// Sets up:
// - Material Design theme
// - Named route navigation (see routes/routes.dart)
// - Initial route (login screen)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookSwap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 29, 78, 255)),
      ),
      // Start at login screen
      initialRoute: AppRoutes.login,
      // Use named routes for navigation (defined in routes/routes.dart)
      onGenerateRoute: generateRoute,
    );
  }
}
