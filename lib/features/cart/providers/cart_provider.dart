import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../common/user_id_provider.dart';
import '../cart_item_model.dart';

class CartNotifier extends StateNotifier<List<Store>> {
  final String userId;
  CartNotifier(this.userId) : super([]);

  // Future<void> fetchCart() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final token = preferences.getString('x-auth-token');
  //   final response = await http.get(
  //     Uri.parse('$uri/auth/cart/$userId'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body) as List;
  //     print(data);
  //     state = data.map((item) => CartItem.fromJson(item)).toList();
  //   }
  // }

// Assuming Cart, Store, CartItem, and Addon classes are already defined

  // Future<void> fetchCart() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final token = preferences.getString('x-auth-token');
  //   final response = await http.get(
  //     Uri.parse('$uri/auth/cart/$userId'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print('Heyyy');
  //     print(response);
  //     final data = json.decode(response.body);
  //     // print(data);
  //     // Parse the response as a List<Store>
  //     List<Cart> cart =
  //         (data as List).map((storeData) => Cart.fromJson(storeData)).toList();
  //     print(cart);
  //     // Set the state to the list of stores
  //     state = cart;
  //   } else {
  //     print('Failed to fetch cart items. Status code: ${response.statusCode}');
  //   }
  // }

  Future<List<Store>> fetchStores() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    final response = await http.get(
      Uri.parse('$uri/auth/cart/$userId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<Store> stores = (data['stores'] as List<dynamic>)
          .map((storeData) => Store.fromJson(storeData as Map<String, dynamic>))
          .toList();
      state = stores;
      return stores;
    } else {
      throw Exception(
          'Failed to fetch stores. Status code: ${response.statusCode}');
    }
  }

  Future<void> addItem(
      String productId, int quantity, String name, double price, String storeId,
      [List<dynamic>? addons]) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    final response = await http.post(
      Uri.parse('$uri/auth/cart/add'),
      body: json.encode({
        "userId": userId,
        "name": name,
        "storeId": storeId,
        "productId": productId,
        "quantity": quantity,
        "price": price,
        "addons": addons
            ?.map((addon) => {
                  "name": addon["name"],
                  "price": addon["price"],
                  "quantity": addon["quantity"] ?? 1,
                })
            .toList(),
      }),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      await fetchStores();
    }
  }

  Future<void> removeItem(String productId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    final response = await http.post(
      Uri.parse('$uri/cart/remove'),
      body: json.encode({
        "userId": userId,
        "productId": productId,
      }),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      await fetchStores();
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Store>>((ref) {
  final userId = ref.watch(userIdProvider).value;
  print('userid:$userId');
  return CartNotifier(userId ?? '');
});
