import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final userIdProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs
      .getString('x-auth-token'); // Assumes the token is saved as 'userToken'

  if (token != null && JwtDecoder.isExpired(token) == false) {
    final decodedToken = JwtDecoder.decode(token);
    print(decodedToken);
    return decodedToken["_id"] as String?;
  }
  return null;
});
