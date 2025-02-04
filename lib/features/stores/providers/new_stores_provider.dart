import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/providers/delivery_address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:m_n_m/constants/global_variables.dart';

class StoreNotifier extends AsyncNotifier<List<dynamic>> {
  @override
  Future<List<dynamic>> build() async {
    return fetchStores();
  }

  Future<List<dynamic>> fetchStores() async {
    final deliveryAddress = ref.read(deliveryAddressProvider);
    if (deliveryAddress == null) {
      return [];
    }

    final url = Uri.parse(
        '$uri/auth/stores?longitude=${deliveryAddress.longitude}&latitude=${deliveryAddress.latitude}');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stores');
    }
  }

  /// **🔹 Manually Refresh Stores**
  Future<void> refreshStores() async {
    state = const AsyncValue.loading(); // Show loading state
    try {
      final newStores = await fetchStores();
      state = AsyncValue.data(newStores);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final storesProvider =
    AsyncNotifierProvider<StoreNotifier, List<dynamic>>(StoreNotifier.new);
