import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../common/user_id_provider.dart';
import '../cart_item_model.dart';

class CartNotifier extends StateNotifier<List<Store>> {
  CartNotifier() : super([]);

  Future<List<Store>> fetchStores() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token is missing.");
      }

      // Decode JWT to extract userId
      String userId;
      final jwt = JwtDecoder.decode(token);
      print(jwt);
      userId = jwt['_id'];

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
            .map((storeData) =>
                Store.fromJson(storeData as Map<String, dynamic>))
            .toList();
        print(jsonDecode(response.body)['stores'][0]);
        state = stores;
        return stores;
      } else {
        print("Error Response: ${response.body}");
        throw Exception(
            "Failed to fetch stores. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Fetch Stores Error: $error");
      return []; // Return an empty list in case of error
    }
  }

  // Future<void> addItem(
  //     String productId, int quantity, String name, double price, String storeId,
  //     [List<dynamic>? addons]) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   final token = preferences.getString('x-auth-token');

  //   if (token == null || token.isEmpty) {
  //     throw Exception("Authentication token is missing.");
  //   }

  //   // Decode JWT to extract userId
  //   String userId;
  //   final jwt = JwtDecoder.decode(token);

  //   userId = jwt['_id'];
  //   final response = await http.post(
  //     Uri.parse('$uri/auth/cart/add'),
  //     body: json.encode({
  //       "userId": userId,
  //       "name": name,
  //       "storeId": storeId,
  //       "productId": productId,
  //       "quantity": quantity,
  //       "price": price,
  //       "addons": addons
  //           ?.map((addon) => {
  //                 "name": addon["name"],
  //                 "price": addon["price"],
  //                 "quantity": addon["quantity"] ?? 1,
  //               })
  //           .toList(),
  //     }),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   print(jsonDecode(response.body));
  //   if (response.statusCode == 200) {

  //     await fetchStores();
  //   }
  // }

  Future<void> addItem(BuildContext context, String productId, int quantity,
      String name, double price, String storeId,
      [List<dynamic>? addons]) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token is missing.");
      }

      // Decode JWT to extract userId
      final jwt = JwtDecoder.decode(token);
      final userId = jwt['_id'];

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

      if (response.statusCode == 200) {
        showCustomSnackbar(
            context: context, message: 'Item added successfully');
        await fetchStores(); // Fetch the updated cart immediately after adding an item
      } else {
        showCustomSnackbar(
            context: context, message: 'Failed to add item to cart');
      }
    } catch (error) {
      showCustomSnackbar(
          context: context, message: 'Failed to add item to cart');
      print("Add Item Error: $error");
    }
  }

  Future<void> removeItem(String productId, String storeId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');

    if (token == null || token.isEmpty) {
      throw Exception("Authentication token is missing.");
    }

    // Decode JWT to extract userId
    String userId;
    final jwt = JwtDecoder.decode(token);

    userId = jwt['_id'];
    print(userId);
    print(productId);
    final response = await http.post(
      Uri.parse('$uri/auth/cart/remove'),
      body: json.encode({
        "userId": userId,
        "productId": productId,
        "storeId": storeId,
      }),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      await fetchStores();
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Store>>((ref) {
  // final userId = ref.watch(userIdProvider).value;
  // print('userid:$userId');
  return CartNotifier();
});

final totalCartItemsProvider = Provider<int>((ref) {
  final stores = ref.watch(cartProvider);
  int totalCount = stores.fold(
      0,
      (sum, store) =>
          sum + store.items.fold(0, (s, item) => s + item.quantity));
  return totalCount;
});

final storeItemCountProvider = Provider.family<int, String>((ref, storeId) {
  final stores = ref.watch(cartProvider);
  final store = stores.firstWhere(
    (store) => store.storeId == storeId,
    orElse: () => Store(
        storeId: storeId,
        items: [],
        id: '',
        storeDetails: StoreDetails(
            name: '', location: '', isOpen: false)), // Default empty store
  );
  return store.items.fold(0, (sum, item) => sum + item.quantity);
});
