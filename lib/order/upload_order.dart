import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/order/confirm_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define your server URL here
final String serverUrl = '$uri/customer/order';

Future<void> uploadOrders(
    List<Map<String, dynamic>> orderData, BuildContext ctx) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('x-auth-token');
  // Convert the list of Store objects to JSON
  //  =
  //     orders.map((order) => order.toJson()).toList();

  try {
    // Make the POST request
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      var orderRes = jsonDecode(response.body);
      print(orderRes['message']['_id']);
      Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (ctx) => OrderConfirmationPage(
                  orderId: orderRes['message']['_id'],
                  itemCost: orderRes['message']['itemCost'].toDouble(),
                  deliveryCost: orderRes['message']['deliveryCost'].toDouble(),
                  totalPrice: orderRes['message']['totalPrice'].toDouble())));
    } else {
      print("Failed to upload orders. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  } catch (e) {
    print("Error occurred while uploading orders: $e");
  }
}
