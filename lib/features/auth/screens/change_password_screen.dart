import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/common/widgets/custom_text_field.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import '../../../common/widgets/custom_buttom_sheet.dart';
import '../../../constants/global_variables.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const routeName = '/change-password-screen';

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isBottomSheetVisible = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  /// **Show Success Sheet**
  void showSuccessSheet(BuildContext context) {
    setState(() {
      isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessSheet(
        title: 'Password Changed Successfully',
        message: 'You can now use your new password to log in to your account.',
        buttonText: 'Login',
        onTapNavigation: SignInScreen.routeName,
      ),
    ).whenComplete(() {
      setState(() {
        isBottomSheetVisible = false;
      });
    });
  }

  /// **Update Password Function**
  Future<void> updatePassword(BuildContext context) async {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar(
          context: context,
          message: "Please fill in all fields",
          duration: const Duration(seconds: 10));
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackbar(
          context: context,
          message: "Passwords do not match",
          duration: const Duration(seconds: 10));
      return;
    }

    setState(() => isLoading = true);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? verificationId = prefs.getString('verificationId');

      if (verificationId == null) {
        showCustomSnackbar(
            context: context,
            message: "No verification ID found. Please try again.",
            duration: const Duration(seconds: 10));
        setState(() => isLoading = false);
        return;
      }

      final response = await http.post(
        Uri.parse('$uri/api/update-password'),
        body: jsonEncode({
          "password": password,
          "verificationId": verificationId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await prefs.remove('verificationId'); // Clear verification ID
        showSuccessSheet(context);
      } else {
        showCustomSnackbar(
            context: context,
            message: responseData['message'] ?? "Something went wrong",
            duration: const Duration(seconds: 10));
      }
    } catch (e) {
      showCustomSnackbar(
          context: context,
          message: "Internal server error. Please try again.",
          duration: const Duration(seconds: 10));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                14.0,
                size.height * 0.10,
                14.00,
                size.height * 0.14,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/main-logo.png',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Change Password',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Kindly enter your new password',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Enter your password',
                      controller: passwordController,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Confirm your password',
                      controller: confirmPasswordController,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      onTap: () => updatePassword(context),
                      title: isLoading ? 'Updating...' : 'Change Password',
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),

          /// **Blur Effect for Bottom Sheet**
          if (isBottomSheetVisible)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
        ],
      ),
    );
  }
}





// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> updatePassword(BuildContext context, String password) async {
//   try {
//     // Retrieve verification ID from local storage
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? verificationId = prefs.getString('verificationId');

//     if (verificationId == null || verificationId.isEmpty) {
//       _showSnackBar(context, "Verification ID is missing.");
//       return;
//     }

//     // API Request
//     final Uri url = Uri.parse('YOUR_API_URL_HERE/api/update-password');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'password': password,
//         'verificationId': verificationId,
//       }),
//     );

//     final Map<String, dynamic> responseBody = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       // Password changed successfully, clear verification ID
//       await prefs.remove('verificationId');
//       _showSnackBar(context, "Password changed successfully!");
//     } else {
//       // Handle various error cases
//       String errorMessage = responseBody['message'] ?? 'Unknown error occurred';
//       _showSnackBar(context, errorMessage);
//     }
//   } catch (e) {
//     print("Update Password Error: $e");
//     _showSnackBar(context, "Something went wrong. Please try again.");
//   }
// }

// // Helper function to show Snackbar messages
// void _showSnackBar(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content
