import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/utils.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showCustomSnackbar(
          context: context,
          message: jsonDecode(response.body)['message'],
          duration: const Duration(seconds: 10));
      break;
    case 500:
      showCustomSnackbar(
          context: context,
          message: jsonDecode(response.body)['error'],
          duration: const Duration(seconds: 10));
      break;
    default:
      showCustomSnackbar(
          context: context,
          message: response.body,
          duration: const Duration(seconds: 10));
  }
}
