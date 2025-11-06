import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Screens/splashscreen.dart';
import 'package:bookswap/Screens/login.dart';
import 'package:bookswap/Screens/home.dart';
import 'package:bookswap/Screens/email_verification.dart';

/// AuthWrapper uses Riverpod to listen to Firebase auth state changes
/// - If user is logged in and email verified -> shows Home screen
/// - If user is logged in but email not verified -> shows Email Verification screen
/// - If user is not logged in -> shows Login screen
/// Firebase automatically tracks login state via authStateChanges stream
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);

    return authStateAsync.when(
      data: (user) {
        if (user != null) {
          // Check if email is verified
          if (!user.emailVerified) {
            return const EmailVerificationScreen();
          }
          // User is logged in and verified
          return const Home();
        }
        // If no user (not logged in), show login screen
        return const Login();
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

