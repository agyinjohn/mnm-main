// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AuthService {
  // sign up user
  Future<bool> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    bool response = false;

    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final int statusCode = res.statusCode;
      print(res.body);
      if (statusCode == 400) {
        // Handle specific error case when user already exists
        final responseBody = jsonDecode(res.body);
        print(responseBody['msg']);
        final message = responseBody['msg'];
        if (responseBody['msg'] == 'User with the same email already exists!') {
          response = false;
          showSnackBar(context, message);
        } else {
          // Handle other validation errors
          final errorMessage =
              responseBody['errors']?[0]['msg'] ?? 'Unknown error';
          showSnackBar(context, errorMessage);
        }
      } else if (statusCode == 200) {
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
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        // ignore: use_build_context_synchronously
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Navigator.pushNamedAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e);
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        // ignore: use_build_context_synchronously
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }
}
