import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
