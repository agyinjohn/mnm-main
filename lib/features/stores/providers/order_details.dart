import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/order_details_model.dart';

class OrderNotifier extends StateNotifier<AsyncValue<OrderDetail?>> {
  OrderNotifier() : super(const AsyncValue.loading());

  Future<void> fetchOrderDetail(String orderId) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('x-auth-token');
      final url = Uri.parse('$uri/customer/orders/details/$orderId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = AsyncValue.data(OrderDetail.fromJson(data));
      } else {
        state = AsyncValue.error(
            'Failed to fetch order: ${response.statusCode}',
            StackTrace.current);
      }
    } catch (error) {
      state = AsyncValue.error('Error: $error', StackTrace.current);
    }
  }
}

// Riverpod Provider
final orderDetailsProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<OrderDetail?>>((ref) {
  return OrderNotifier();
});
