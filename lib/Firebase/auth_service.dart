import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  // Lazy initialization of FirebaseAuth to avoid errors if Firebase isn't initialized
  FirebaseAuth? _auth;
  
  FirebaseAuth get auth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

  // Check if Firebase is initialized
  bool get isFirebaseInitialized {
    try {
      final apps = Firebase.apps;
      return apps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  User? get currentUser {
    if (!isFirebaseInitialized) return null;
    try {
      return auth.currentUser;
    } catch (e) {
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    if (!isFirebaseInitialized) {
      throw 'Firebase is not initialized. Please stop the app completely, rebuild with "flutter run", and ensure google-services.json is correctly configured in android/app/.';
    }
    
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with display name
      if (userCredential.user != null && (firstName != null || lastName != null)) {
        String displayName = [firstName, lastName].where((name) => name != null && name.isNotEmpty).join(' ');
        if (displayName.isNotEmpty) {
          await userCredential.user?.updateDisplayName(displayName);
          await userCredential.user?.reload();
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    if (!isFirebaseInitialized) {
      throw 'Firebase is not initialized. Please stop the app completely, rebuild with "flutter run", and ensure google-services.json is correctly configured in android/app/.';
    }
    
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    if (!isFirebaseInitialized) return;
    try {
      await auth.signOut();
    } catch (e) {
      // Silently fail if Firebase isn't initialized
    }
  }

  // Handle Firebase auth exceptions and return user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

