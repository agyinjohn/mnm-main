import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/features/auth/screens/otp_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isBottomSheetVisible = false;

    void showSuccessSheet(BuildContext context) {
      setState(() {
        isBottomSheetVisible = true;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const SuccessSheet(
          title: 'Email Verified Successfully',
          message:
              'An OPT (One-Time Password) has been sent to your regiestered email address/phone number.',
          buttonText: 'Continue',
          onTapNavigation: '/otp',
        ),
      ).whenComplete(() {
        setState(() {
          isBottomSheetVisible = false;
        });
      });
    }

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
                    const CustomTextField(
                      isPassword: false,
                      prefixIcon: Icons.mail,
                      hintText: 'Enter your email or phone number',
                    ),
                    const SizedBox(height: 22),
                    CustomButton(
                        onTap: () => showSuccessSheet(context),
                        title: 'Confirm Email'),
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
                          onPressed: () =>
                              Navigator.pushNamed(context, OTPScreen.routeName),
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
