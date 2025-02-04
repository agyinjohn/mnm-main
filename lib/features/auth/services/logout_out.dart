import 'package:flutter/material.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel logout
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm logout
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );

  if (shouldLogout == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token'); // Clear token
    await prefs.setBool('hasLoggedInBefore', true);
    // Navigate to login screen & remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false, // Prevents back navigation
    );
  }
}
