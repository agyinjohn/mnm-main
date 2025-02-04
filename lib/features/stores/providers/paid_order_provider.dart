import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'dart:convert';

import 'package:m_n_m/order/paid_order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final orderProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderNotifier() : super(const AsyncValue.loading()) {
    fetchOrders(); // Automatically fetch orders when the notifier is created
  }

  Future<void> fetchOrders() async {
    final url = '$uri/customer/orders/ALL';

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    try {
      print('fetchingd');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token!,
          "Content-Type": "application/json",
        },
      );
      // print(response.body);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print('hereree');
        final data = json.decode(response.body) as List<dynamic>;
        print(data);
        final orders = data.map((order) => Order.fromJson(order)).toList();
        print(orders);
        state = AsyncValue.data(orders);
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      print(e.toString());
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
