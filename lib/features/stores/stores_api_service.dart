import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'stores_model.dart';

// class StoreService {
//   static String baseUrl = "$uri/auth/stores";
//   // Replace with your token

//   Future<List<CategoryResponse>> fetchNearbyStores(
//       String longitude, String latitude) async {
// SharedPreferences preferences = await SharedPreferences.getInstance();
// final token = preferences.getString('x-auth-token');
//     final url = Uri.parse('$baseUrl?longitude=$longitude&latitude=$latitude');
//     final response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       final List data = json.decode(response.body);
//       print(data);
//       return data.map((json) => CategoryResponse.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load stores');
//     }
//   }
// }

class StoreService {
  // static const String apiUrl = 'http://localhost:8000/auth/stores';
  static String baseUrl = "$uri/auth/stores";
  Future<List<dynamic>> fetchStores(double longitude, double latitude) async {
    final url = Uri.parse('$baseUrl?longitude=$longitude&latitude=$latitude');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('x-auth-token');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Replace with a valid token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
