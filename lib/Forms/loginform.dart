import 'package:flutter/material.dart';
import 'package:bookswap/routes/routes.dart';
import 'package:bookswap/Firebase/auth_service.dart';

class LoginForm {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  // Validate all fields
  bool validate() {
    if (formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  final AuthService _authService = AuthService();

  Future<void> login(BuildContext context) async {
    if (validate()) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Sign in with Firebase
        await _authService.signIn(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // Close loading indicator
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          // Navigate to splash/home screen
          Navigator.pushNamed(context, AppRoutes.splash);
        }
      } catch (e) {
        // Close loading indicator
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}