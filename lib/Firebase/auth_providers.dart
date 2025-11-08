//
/// AUTHENTICATION PROVIDERS
//
// 
// Riverpod providers for Firebase Authentication.
// 
// PROVIDERS:
// - authServiceProvider: Singleton instance of AuthService
// - authStateChangesProvider: Stream of auth state changes (login/logout/verification)
// - currentUserStreamProvider: Stream of current user (simpler than authStateChanges)
// - currentUserProvider: Synchronous access to current user
// - isLoggedInProvider: Boolean indicating if user is logged in
// 
// USAGE:
//   final user = ref.watch(currentUserStreamProvider);
//   final isLoggedIn = ref.watch(isLoggedInProvider);
// 
//

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookswap/Firebase/auth_service.dart';

// Provider for AuthService instance (singleton)
// 
// Provides a single instance of AuthService throughout the app.
// Used by other auth providers to access Firebase Auth.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// StreamProvider that listens to Firebase auth state changes
// 
// IMPORTANT: Uses userChanges() instead of authStateChanges() because:
// - userChanges() emits when user profile changes (like email verification status)
// - authStateChanges() only emits on login/logout
// 
// This ensures the app automatically updates when:
// - User logs in/out
// - Email verification status changes
// - User profile is updated
// 
// Returns: StreamProvider<User?> - emits User when logged in, null when logged out
final authStateChangesProvider = StreamProvider<User?>((ref) async* {
  final authService = ref.watch(authServiceProvider);
  
  // Emit current user immediately (with reload) to avoid waiting for first stream emission
  final initialUser = authService.currentUser;
  String? lastYieldedUserId;
  bool? lastYieldedVerified;
  
  if (initialUser != null) {
    try {
      await initialUser.reload();
      final updatedInitialUser = authService.currentUser;
      if (updatedInitialUser != null) {
        lastYieldedUserId = updatedInitialUser.uid;
        lastYieldedVerified = updatedInitialUser.emailVerified;
        yield updatedInitialUser;
      } else {
        lastYieldedUserId = initialUser.uid;
        lastYieldedVerified = initialUser.emailVerified;
        yield initialUser;
      }
    } catch (e) {
      lastYieldedUserId = initialUser.uid;
      lastYieldedVerified = initialUser.emailVerified;
      yield initialUser;
    }
  } else {
    yield null;
  }
  
  // Then listen to user changes (includes profile changes like email verification)
  // This stream automatically emits when user logs in/out AND when profile changes
  await for (final user in authService.userChanges) {
    if (user != null) {
      // Check if user ID or verification status actually changed
      final userId = user.uid;
      final isVerified = user.emailVerified;
      
      final hasChanged = lastYieldedUserId != userId || 
                         lastYieldedVerified != isVerified;
      
      if (hasChanged) {
        // User changed or verification status changed - reload and yield
        try {
          await user.reload();
          final updatedUser = authService.currentUser;
          if (updatedUser != null) {
            lastYieldedUserId = updatedUser.uid;
            lastYieldedVerified = updatedUser.emailVerified;
            yield updatedUser;
          } else {
            lastYieldedUserId = userId;
            lastYieldedVerified = isVerified;
            yield user;
          }
        } catch (e) {
          // If reload fails, yield the user anyway
          lastYieldedUserId = userId;
          lastYieldedVerified = isVerified;
          yield user;
        }
      }
      // If nothing changed, skip this emission (don't yield)
    } else {
      // User logged out - only yield if we had a user before
      if (lastYieldedUserId != null) {
        lastYieldedUserId = null;
        lastYieldedVerified = null;
        yield null;
      }
    }
  }
});

// StreamProvider for current user - updates automatically when profile changes
// 
// Simpler version of authStateChangesProvider.
// Uses userChanges() to catch email verification status updates.
// 
// Returns: StreamProvider<User?> - emits User when logged in, null when logged out
final currentUserStreamProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.userChanges;
});

// Provider for current user (synchronous access)
// 
// Provides immediate access to current user without waiting for stream.
// Uses the latest value from Firebase Auth.
// 
// Returns: Provider<User?> - current user or null if not logged in
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// Provider to check if user is logged in
// 
// Convenience provider that returns true if user is logged in, false otherwise.
// 
// Returns: Provider<bool> - true if logged in, false otherwise
final isLoggedInProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser != null;
});

