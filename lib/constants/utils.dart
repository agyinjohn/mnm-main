import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'dart:convert';

import 'package:m_n_m/features/home/widgets/show_phone_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

String formatDate(String date) {
  try {
    // Parse the date string
    final DateTime parsedDate = DateTime.parse(date);

    // Format it into the desired format
    final String formattedDate =
        DateFormat('EEEE, MMMM d, y').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle invalid date strings
    return 'Invalid date';
  }
}

String formatDateTime(String dateTime) {
  try {
    // Parse the ISO 8601 date-time string
    final DateTime parsedDateTime = DateTime.parse(dateTime);

    // Format it into the desired format
    final String formattedDateTime =
        DateFormat('EEEE, MMMM d, y h:mm a').format(parsedDateTime);

    return formattedDateTime;
  } catch (e) {
    // Handle invalid date-time strings
    return 'Invalid date-time';
  }
}

// Future<void> googleSignIn(BuildContext context) async {
//   try {
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     // Force sign-out to ensure the pop-up appears
//     await googleSignIn.signOut();

//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     if (googleUser == null) return; // User canceled sign-in

//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     final String idToken = googleAuth.idToken!;
//     print("ID Token: $idToken");

//     final response = await http.post(
//       Uri.parse('https://your-backend.com/api/auth/google'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'idToken': idToken}),
//     );

//     final data = jsonDecode(response.body);
//     print("User authenticated: $data");
//   } catch (e) {
//     print("Google Sign-In Error: $e");
//   }
// }

Future<void> googleSignUp(BuildContext context) async {
  void showLoadingDialog(BuildContext context) {
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

  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    showLoadingDialog(context);
    await googleSignIn.signOut(); // Sign out the existing user

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    print(googleUser);
    if (googleUser == null) return; // User canceled sign-in

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String idToken = googleAuth.idToken!;

    String? phoneNumber = await showPhoneNumberDialog(context);

    if (phoneNumber == null || phoneNumber.isEmpty) {
      print("User didn't enter phone number");
      return;
    }

    // Extract user details
    final userData = {
      "name": googleUser.displayName,
      "email": googleUser.email,
      "password": null, // No password for Google sign-up
      "phoneNumber": phoneNumber, // User can add later
      "role": "customer", // Default role
      "googleIdToken": idToken
    };

    print("Google User Data: $userData");

    // Send data to backend registration endpoint

    print(">>>>>>");
    http.Response res = await http.post(
      Uri.parse('$uri/api/google-signup'),
      body: jsonEncode(userData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Navigator.pop(context);
    final int statusCode = res.statusCode;
    // print(res.body);
    // print(statusCode);
    if (statusCode == 400) {
      // Handle specific error case when user already exists
      final responseBody = jsonDecode(res.body);
      print(responseBody['message']);
      final message = responseBody['msg'];
      if (responseBody['msg'] == 'User with the same email already exists!') {
        showCustomSnackbar(
            context: context,
            message: message,
            duration: const Duration(seconds: 10));
      } else {
        // Handle other validation errors
        final errorMessage = responseBody['message'] ?? 'Unknown error';
        showCustomSnackbar(
            context: context,
            message: errorMessage,
            duration: const Duration(seconds: 10));
      }
    } else if (statusCode == 201) {
      await googleSignIn.signOut();
      final responseBody = jsonDecode(res.body);
      showCustomSnackbar(
          context: context,
          message: "You have Sucessfully Sign Up ",
          duration: const Duration(seconds: 10));
      print("User registered successfully: ${responseBody['user']}");
    } else {
      // Handle other status codes
      showCustomSnackbar(
          context: context,
          message: "Something went wrong. Please try again.",
          duration: const Duration(seconds: 10));
    }

    // final responseData = jsonDecode(response.body);
    // print("Response: $responseData");
  } catch (e) {
    showCustomSnackbar(
        context: context,
        message: "Something went wrong. Please try again.",
        duration: const Duration(seconds: 10));
    // print("Google Sign-Up Error: $e");
  }
}

Future<Map<String, dynamic>> sendVerificationNumber(String email) async {
  final String url =
      "$uri/reset-password/$email"; // Replace with actual API endpoint

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      // Save verificationId and userId locally for further use
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("verificationId", data["verificationId"]);
      await prefs.setString("userId", data["userId"]);

      return {"success": true, "message": "Verification code sent!"};
    } else {
      return {
        "success": false,
        "message": data["message"] ?? "Something went wrong!"
      };
    }
  } catch (error) {
    return {
      "success": false,
      "message": "Internal server error. Please try again."
    };
  }
}
