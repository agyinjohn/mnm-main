import 'package:flutter/material.dart';
import 'package:m_n_m/features/auth/screens/forgot_password.dart';
import 'package:m_n_m/features/auth/screens/sign_up_screen.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../../common/widgets/custom_button_2.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../constants/global_variables.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const routeName = '/sign-in-screen';
  @override
  State<SignInScreen> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInScreen> {
  final List<Image> accounts = [
    Image.asset('assets/images/g.png'),
    Image.asset('assets/images/a.png'),
    Image.asset('assets/images/f.png'),
  ];

  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  void signInUser() async {
    try {
      setState(() {
        loading = true;
      });
      await authService.signInUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            14.0,
            size.height * 0.10,
            14.00,
            size.height * 0.06,
          ),
          child: Center(
            child: Form(
              key: _signInFormKey,
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
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kindly enter your details to login.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 75,
                    color: Colors.transparent,
                    child: CustomTextField(
                      controller: _emailController,
                      isPassword: false,
                      prefixIcon: Icons.mail,
                      hintText: 'Email',
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 75,
                    child: CustomTextField(
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      hintText: 'Password',
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ForgotPasswordScreen.routeName);
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.orange,
                          decorationColor: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                      onTap: () {
                        if (_signInFormKey.currentState!.validate()) {
                          signInUser();
                        }
                      },
                      title: 'Login'),
                  const SizedBox(height: 24),
                  const Text(
                    'Or continue with',
                    style: TextStyle(fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: accounts.map((image) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          width: 54,
                          height: 54,
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
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, SignUpScreen.routeName),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.orange,
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
      ]),
    );
  }
}
