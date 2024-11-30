// import 'dart:ui';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/common/widgets/custom_text_field.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';

import '../../../common/widgets/custom_buttom_sheet.dart';
import '../../../constants/global_variables.dart';

// import '../widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  static const routeName = '/change-password-screen';
  @override
  State<ChangePasswordScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
    final List<TextEditingController> controllers =
        List.generate(6, (_) => TextEditingController());

    void nextField(String value, int index) {
      if (value.length == 1 && index < 5) {
        focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
      if (value.length == 1 && index == 5) {
        focusNodes[index].unfocus();
      }
    }

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
          title: 'Password Changed Successfully',
          message:
              'You can now use your new password to log in to your account.',
          buttonText: 'Login',
          onTapNavigation: SignInScreen.routeName,
        ),
      ).whenComplete(() {
        setState(() {
          isBottomSheetVisible = false;
        });
      });

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
            text: const TextSpan(style: TextStyle(fontSize: 12), children: [
          TextSpan(
            text: 'If you did not request this change,\n',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'contact support',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.errorColor),
          ),
          TextSpan(
            text: ' immediately.',
            style: TextStyle(color: Colors.black),
          ),
        ])),
      );
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
                size.height * 0.22,
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
                      'Change Password.',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                            textAlign: TextAlign.center,
                            'Kindly enter your new password')),
                    const SizedBox(height: 24),
                    const CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Enter your password',
                    ),
                    const SizedBox(height: 14),
                    const CustomTextField(
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Confirm your password',
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                        onTap: () => showSuccessSheet(context),
                        title: 'Change Password'),
                    const Spacer(),
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