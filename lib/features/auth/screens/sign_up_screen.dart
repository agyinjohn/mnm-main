// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/common/widgets/custom_text_field.dart';
import 'package:m_n_m/constants/utils.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../../common/widgets/custom_buttom_sheet.dart';
import '../../../constants/global_variables.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameControler = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  bool loading = false;
  final _signUpFormKey = GlobalKey<FormState>();
  signUpUser() async {
    if (passwordController.text.trim() ==
        confirmPasswordController.text.trim()) {
      try {
        setState(() {
          loading = true;
        });
        final res = await authService.signUpUser(
            phone: _phoneController.text,
            context: context,
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name:
                '${firstNameController.text.trim()}  ${secondNameControler.text.trim()}');
        setState(() {
          loading = false;
        });
        if (res) {
          showSuccessSheet(context);
          setState(() {
            emailController.text = '';
            passwordController.text = '';
            confirmPasswordController.text = '';
            firstNameController.text = '';
            secondNameControler.text = '';
          });
        }
      } catch (e) {
        showSnackBar(context, "An unexpected error occured");
        setState(() {
          loading = false;
        });
      }
    } else {
      showSnackBar(context, 'Please make sure passwords are equal');
    }
  }

  // void signInUser() {
  //   authService.signInUser(
  //     context: context,
  //     email: _emailController.text,
  //     password: _passwordController.text,
  //   );
  // }

  final List<Image> accounts = [
    Image.asset('assets/images/g.png'),
    Image.asset('assets/images/a.png'),
    Image.asset('assets/images/f.png'),
  ];

  bool _isBottomSheetVisible = false;

  void showSuccessSheet(BuildContext context) {
    setState(() {
      _isBottomSheetVisible = true;
    });

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessSheet(
        title: 'Account successfully created!',
        message:
            'Welcome to M&M Delivery App!\nStart exploring all the features we have to offer.',
        buttonText: 'Login to Explore',
        onTapNavigation: SignInScreen.routeName,
      ),
    ).whenComplete(() {
      setState(() {
        _isBottomSheetVisible = false;
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
                size.height * 0.01,
                14.0,
                size.height * 0.01,
              ),
              child: Center(
                child: Form(
                  key: _signUpFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   // color: Colors.green,
                        //   height: 100,
                        //   width: 100,
                        //   child: Image.asset(
                        //     'assets/images/main-logo.png',
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create an account.',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          textAlign: TextAlign.center,
                          'Please fill in the details below to create your account.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: CustomTextField(
                                  controller: firstNameController,
                                  isPassword: false,
                                  prefixIcon: Icons.person,
                                  hintText: 'First name',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SizedBox(
                                height: 70,
                                child: CustomTextField(
                                  controller: secondNameControler,
                                  isPassword: false,
                                  prefixIcon: Icons.person,
                                  hintText: 'Last name',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 70,
                          child: CustomTextField(
                            controller: emailController,
                            isPassword: false,
                            prefixIcon: Icons.email,
                            hintText: 'Email',
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: CustomTextField(
                            controller: _phoneController,
                            isPassword: false,
                            prefixIcon: Icons.email,
                            hintText: 'Phone Number',
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: CustomTextField(
                            controller: passwordController,
                            isPassword: true,
                            prefixIcon: Icons.lock,
                            hintText: 'Password',
                          ),
                        ),
                        SizedBox(
                          height: 70,
                          child: CustomTextField(
                            controller: confirmPasswordController,
                            isPassword: true,
                            prefixIcon: Icons.lock,
                            hintText: 'Confirm password',
                          ),
                        ),
                        CustomButton(
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpUser();
                              }
                            },
                            title: 'Sign Up'),
                        const SizedBox(height: 10),
                        const Text(
                          'Or continue with',
                          style: TextStyle(fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: accounts.map((image) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: image,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
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
            ),
          ),

          // Blur effect when the bottom sheet is visible
          if (_isBottomSheetVisible)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          if (loading)
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(color: Colors.white70),
              child: Center(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  width: 50,
                  child: const Center(
                    child: NutsActivityIndicator(
                      radius: 15,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
