// import 'dart:ui';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:m_n_m/features/auth/screens/change_password_screen.dart';

import '../../../common/widgets/custom_buttom_sheet.dart';
import '../../../common/widgets/custom_button_2.dart';
import '../../../constants/global_variables.dart';

// import '../widgets/custom_textfield.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  static const routeName = '/otp-screen';
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
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

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

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
        title: 'OTP Verified Successfully',
        message: 'Your OTP(One Time Password) has been verified successfully.',
        buttonText: 'Continue',
        onTapNavigation: ChangePasswordScreen.routeName,
      ),
    ).whenComplete(() {
      setState(() {
        isBottomSheetVisible = false;
      });
    });
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
                      'OTP Verification',
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
                            'Kindly enter the 6 digit code sent to your\nphone number or email.')),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) {
                          return Container(
                              decoration: const BoxDecoration(
                                  color: AppColors.secondaryColor),
                              width: 52,
                              height: 80,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: SizedBox(
                                    height: 60,
                                    child: TextFormField(
                                      controller: controllers[index],
                                      focusNode: focusNodes[index],
                                      maxLength: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 24,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color:
                                                Color.fromRGBO(243, 156, 18, 3),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      onChanged: (value) =>
                                          nextField(value, index),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                        onTap: () => showSuccessSheet(context),
                        title: 'Verify OTP'),
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
