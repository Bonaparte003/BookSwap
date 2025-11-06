import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookswap/Firebase/auth_service.dart';

// Provider for AuthService instance (singleton)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// StreamProvider that listens to Firebase auth state changes
// Uses userChanges() instead of authStateChanges() because userChanges() also emits
// when user profile changes (like email verification status)
// This automatically updates when user logs in/out AND when email verification status changes
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
// Uses userChanges() to also catch email verification status updates
final currentUserStreamProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.userChanges;
});

// Provider for current user (synchronous access - uses stream's latest value)
final currentUserProvider = Provider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

// Provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser != null;
});

