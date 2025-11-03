import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Screens/splashscreen.dart';
import 'package:bookswap/Screens/login.dart';
import 'package:bookswap/Screens/home.dart';

/// AuthWrapper uses Riverpod to listen to Firebase auth state changes
/// - If user is logged in -> shows Home screen
/// - If user is not logged in -> shows Login screen
/// Firebase automatically tracks login state via authStateChanges stream
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);

    return authStateAsync.when(
      data: (user) {
        // If user exists (logged in), show home screen
        if (user != null) {
          return const Home();
        }
        // If no user (not logged in), show login screen
        return Login();
      },
      loading: () => const Splashscreen(),
      error: (error, stackTrace) {
        // On error, show login screen (better than crashing)
        debugPrint('Auth state error: $error');
        return Login();
      },
    );
  }
}

