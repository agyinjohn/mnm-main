import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/auth/screens/onboarding_screen.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/router.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final AuthService authService = AuthService();
  bool isTokenValid = false;
  String? userRole;
  bool isloading = true;
  bool isUser = false;
  @override
  void initState() {
    super.initState();
    // authService.getUserData(context);
    checkTokenValidity();
  }

  Future<void> checkTokenValidity() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    final isUserLoggedIn = preferences.getBool('isUser') ?? false;
    setState(() {
      isloading = true;
      isUser = isUserLoggedIn;
    });
    try {
      if (token != null && !JwtDecoder.isExpired(token)) {
        // Decode token to get user role
        final decodedToken = JwtDecoder.decode(token);
        setState(() {
          isTokenValid = true;
          userRole =
              decodedToken['role']; // Assuming 'role' is in the token payload
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isTokenValid = false;
        isloading = false;
      });
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MNM',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          // const RoutingMap(),

          isTokenValid
              ? (userRole == 'customer'
                  ? const HomeScreen()
                  : const SignInScreen())
              : isloading
                  ? const Scaffold(body: Center(child: NutsActivityIndicator()))
                  : isUser
                      ? const SignInScreen()
                      : const OnboardingScreen(),
    );
  }
}
