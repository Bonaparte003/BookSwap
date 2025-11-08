/// ============================================================================
/// AUTHENTICATION WRAPPER
/// ============================================================================
/// 
/// This widget handles authentication state and routes users to the correct screen.
/// 
/// AUTHENTICATION FLOW:
/// 1. Listens to Firebase Auth state changes via authStateChangesProvider
/// 2. Determines which screen to show based on auth state:
///    - Logged in + email verified → Home screen
///    - Logged in + email NOT verified → Email Verification screen
///    - Not logged in → Login screen
/// 
/// HOW IT WORKS:
/// - Uses Riverpod's ConsumerWidget to watch authStateChangesProvider
/// - Firebase automatically emits auth state changes (login, logout, etc.)
/// - Widget rebuilds automatically when auth state changes
/// 
/// IMPORTANT:
/// - This widget should be used as the root widget in routes that require
///   authentication checking (currently used in main.dart via routes)
/// - The auth state is reactive - no manual refresh needed
/// 
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookswap/Firebase/auth_providers.dart';
import 'package:bookswap/Screens/login.dart';
import 'package:bookswap/Screens/home.dart';
import 'package:bookswap/Screens/email_verification.dart';

/// Authentication wrapper widget
/// 
/// Automatically routes users based on their authentication state:
/// - Logged in + email verified → Home screen
/// - Logged in + email NOT verified → Email Verification screen  
/// - Not logged in → Login screen
/// 
/// Uses Riverpod to watch Firebase auth state changes in real-time.
/// Firebase automatically tracks login state via authStateChanges stream.
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch Firebase auth state changes (reactive - updates automatically)
    final authStateAsync = ref.watch(authStateChangesProvider);

    // Handle different auth states
    return authStateAsync.when(
      data: (user) {
        if (user != null) {
          // User is logged in - check if email is verified
          if (!user.emailVerified) {
            // Email not verified - show verification screen
            return const EmailVerificationScreen();
          }
          // User is logged in and email verified - show main app
          return const Home();
        }
        // No user logged in - show login screen
        return const Login();
      },
      loading: () => const Scaffold(
        // Show loading indicator while checking auth state
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        // On error, show login screen (better than crashing)
        debugPrint('Auth state error: $error');
        return Login();
      },
    );
  }
}

