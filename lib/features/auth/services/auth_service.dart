// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user.dart';

class AuthService {
  // sign up user
  Future<bool> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    bool response = false;

    try {
      User user = User(
          id: email,
          name: name,
          password: password,
          email: email,
          address: '',
          role: 'customer',
          token: '',
          phoneNumber: phone);
      print(user.role);
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final int statusCode = res.statusCode;
      // print(res.body);
      // print(statusCode);
      if (statusCode == 400) {
        // Handle specific error case when user already exists
        final responseBody = jsonDecode(res.body);
        print(responseBody['message']);
        final message = responseBody['msg'];
        if (responseBody['msg'] == 'User with the same email already exists!') {
          response = false;
          showSnackBar(context, message);
        } else {
          // Handle other validation errors
          final errorMessage = responseBody['message'] ?? 'Unknown error';
          showSnackBar(context, errorMessage);
        }
      } else if (statusCode == 201) {
        response = true;
      } else {
        // Handle other status codes
        showSnackBar(context, 'Something went wrong. Please try again.');
      }
    } catch (e) {
      response = false;
      // ignore: use_build_context_synchronously
      response = false;
      print('Exception: $e');
      showSnackBar(context, 'An error occurred: ${e.toString()}');
    }
    return response;
  }

  // sign in user
  Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      print(email);
      print(password);
      http.Response res = await http.post(
        Uri.parse('$uri/api/login'),
        body: jsonEncode({
          'id': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Server response timeout');
        },
      );

      print(jsonDecode(res.body));

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // Decode the token and check user role
          final data = jsonDecode(res.body);
          String token = data['token'];
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
        },
      );
    } on SocketException catch (s) {
      showCustomSnackbar(
          context: context, message: 'Could not connect to server');
    } on TimeoutException catch (t) {
      showCustomSnackbar(context: context, message: t.message.toString());
    } catch (e) {
      print(e);
      showCustomSnackbar(
          context: context, message: 'Something unexpected happened');
    }
  }

  // get user data
  // void getUserData(
  //   BuildContext context,
  // ) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('x-auth-token');

  //     if (token == null) {
  //       prefs.setString('x-auth-token', '');
  //     }

  //     var tokenRes = await http.post(
  //       Uri.parse('$uri/tokenIsValid'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': token!
  //       },
  //     );

  //     var response = jsonDecode(tokenRes.body);

  //     if (response == true) {
  //       http.Response userRes = await http.get(
  //         Uri.parse('$uri/'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'x-auth-token': token
  //         },
  //       );

  //       // ignore: use_build_context_synchronously
  //     }
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     showSnackBar(context, e.toString());
  //   }
  // }
}
