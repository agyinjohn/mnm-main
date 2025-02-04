// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:m_n_m/constants/global_variables.dart';
// import 'dart:convert';

// import 'package:m_n_m/models/delivery_address_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PopularStoresState {
//   final List<Map<String, dynamic>> stores;
//   final bool isLoading;
//   final String? errorMessage;

//   PopularStoresState({
//     required this.stores,
//     required this.isLoading,
//     this.errorMessage,
//   });

//   PopularStoresState copyWith({
//     List<Map<String, dynamic>>? stores,
//     bool? isLoading,
//     String? errorMessage,
//   }) {
//     return PopularStoresState(
//       stores: stores ?? this.stores,
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage,
//     );
//   }
// }

// class PopularStoresNotifier extends StateNotifier<PopularStoresState> {
//   PopularStoresNotifier()
//       : super(PopularStoresState(stores: [], isLoading: false));

//   Future<void> fetchPopularStores(DeliveryAddress deliveryAddress) async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       final token = pref.getString('x-auth-token');
//       final headers = {
//         "Authorization": "Bearer $token",
//         "Content-Type": "application/json",
//       };

//       final url = Uri.parse(
//           "$uri/customer/popular-stores?longitude=${deliveryAddress.longitude}&latitude=${deliveryAddress.latitude}");

//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);

//         state = state.copyWith(
//           stores: data.map((store) => store as Map<String, dynamic>).toList(),
//           isLoading: false,
//         );
//       } else {
//         state = state.copyWith(
//           errorMessage: "Failed to fetch stores: ${response.statusCode}",
//           isLoading: false,
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         errorMessage: "Error: ${e.toString()}",
//         isLoading: false,
//       );
//     }
//   }
// }

// // Riverpod provider
// final popularStoresProvider =
//     StateNotifierProvider<PopularStoresNotifier, PopularStoresState>(
//   (ref) => PopularStoresNotifier(),
// );

//

// PopularStoresNotifier
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/models/delivery_address_model.dart';
import 'package:m_n_m/providers/delivery_address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/global_variables.dart';

class PopularStoresNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  PopularStoresNotifier(this.ref) : super(const AsyncValue.loading()) {
    // Listen for changes in deliveryAddressProvider
    ref.listen<DeliveryAddress?>(
      deliveryAddressProvider,
      (previous, next) {
        if (next != null && next != previous) {
          fetchPopularStores(
              next); // Fetch stores when delivery address changes
        }
      },
    );
  }

  final Ref ref;

  Future<void> fetchPopularStores(DeliveryAddress deliveryAddress) async {
    state = const AsyncValue.loading(); // Set loading state
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('x-auth-token');
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      final url = Uri.parse(
          "$uri/customer/popular-stores?longitude=${deliveryAddress.longitude}&latitude=${deliveryAddress.latitude}");

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final stores =
            data.map((store) => store as Map<String, dynamic>).toList();
        state = AsyncValue.data(stores);
      } else {
        state = AsyncValue.error(
          "Failed to fetch stores: ${response.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Popular stores provider
final popularStoresProvider = StateNotifierProvider<PopularStoresNotifier,
    AsyncValue<List<Map<String, dynamic>>>>(
  (ref) => PopularStoresNotifier(ref),
);
