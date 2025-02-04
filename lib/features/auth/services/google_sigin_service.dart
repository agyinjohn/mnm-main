import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceG {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Show loading dialog
      _showLoadingDialog(context);
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        Navigator.pop(context); // Close loading dialog
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Navigator.pop(context); // Close loading dialog
        throw Exception("Google ID token is null");
      }

      // Send ID token to backend for authentication
      final response = await http.post(
        Uri.parse('$uri/api/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'googleIdToken': idToken}),
      );

      final responseData = jsonDecode(response.body);

      Navigator.pop(context); // Close loading dialog

      if (response.statusCode == 200) {
        // Save token and user details in local storage
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', responseData['token']);
        // await prefs.setString('user', jsonEncode(responseData['user']));

        // Navigate to home or dashboard
        //  final data = jsonDecode(response.body);
        String token = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String? role = decodedToken['role'];

        // Check if the user role is "customer"
        if (role == 'customer') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Save the token
          await prefs.setString('x-auth-token', token);

          // Navigate to the HomeScreen
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        } else {
          // Show an error message if the role is not "customer"
          showCustomSnackbar(
            context: context,
            message: 'You are not authorized to access this app',
          );
        }
      } else {
        _showErrorSnackBar(context, responseData['message']);
      }
    } catch (error) {
      Navigator.pop(context); // Close loading dialog
      print("Google Sign-In Error: $error");
      _showErrorSnackBar(context, "Google Sign-In Failed");
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored user data
  }

  // Show loading dialog
  static void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text("Signing in...", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show error message in SnackBar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
