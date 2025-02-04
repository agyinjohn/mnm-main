import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/features/auth/screens/otp_screen.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../common/widgets/custom_buttom_sheet.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../constants/global_variables.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isBottomSheetVisible = false;
  bool isLoading = false;

  Future<void> sendVerificationNumber(String email) async {
    final String url =
        "$uri/api/reset-password/$email"; // Replace with actual API endpoint
    print(url);
    setState(() => isLoading = true);

    try {
      print('eeee');
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      print(response.body);
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // Save verificationId and userId locally for further use
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("verificationId", data["verificationId"]);
        await prefs.setString("userId", data["userId"]);

        showSuccessSheet();
      } else {
        showErrorSnackBar(data["message"] ?? "Something went wrong!");
      }
    } catch (error) {
      print(error.toString());
      showErrorSnackBar("Internal server error. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSuccessSheet() {
    setState(() => isBottomSheetVisible = true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessSheet(
        title: 'Email Verified Successfully',
        message:
            'An OTP (One-Time Password) has been sent to your registered email address/phone number.',
        buttonText: 'Continue',
        onTapNavigation: '/otp-screen',
      ),
    ).whenComplete(() {
      setState(() => isBottomSheetVisible = false);
    });
  }

  void showErrorSnackBar(String message) {
    showCustomSnackbar(context: context, message: message);
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
                size.height * 0.16,
                14.00,
                size.height * 0.14,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'assets/images/main-logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: emailController,
                      isPassword: false,
                      prefixIcon: Icons.mail,
                      hintText: 'Enter your email or phone number',
                    ),
                    const SizedBox(height: 22),
                    CustomButton(
                      onTap: isLoading
                          ? () {}
                          : () {
                              if (emailController.text.isNotEmpty) {
                                sendVerificationNumber(
                                    emailController.text.trim());
                              } else {
                                showErrorSnackBar(
                                    "Please enter a valid email or phone number.");
                              }
                            },
                      title: isLoading ? "Sending..." : "Confirm Email",
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Remembered password?',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, SignInScreen.routeName),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Blur effect when the bottom sheet is visible
          if (isBottomSheetVisible)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }
}
