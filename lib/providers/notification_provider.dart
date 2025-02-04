import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/models/notification_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

// StateNotifier to manage the state of notifications
class NotificationNotifier extends StateNotifier<List<NotificationModel>> {
  NotificationNotifier() : super([]);

  bool _isCached = false;

  // Fetch notifications from the API
  Future<void> fetchNotifications() async {
    if (_isCached) return; // Use cached data if available
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final authToken = sharedPreferences.getString('token');
    final url = Uri.parse("$uri/rider/notifications");
    final headers = {
      "Authorization": "Bearer $authToken", // Replace with your token
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['notifications'] as List;
        final notifications =
            data.map((json) => NotificationModel.fromJson(json)).toList();
        state = notifications;
        _isCached = true; // Cache the data
      } else {
        throw Exception("Failed to load notifications");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse("$uri/rider/notifications/$notificationId");

    // Optimistically update the UI
    state = state.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        await fetchNotifications(); // Refetch notifications after success
      } else {
        throw Exception("Failed to update notification");
      }
    } catch (e) {
      print("Error updating notification: $e");
    }
  }

  // Force refresh (ignoring the cache)
  Future<void> refreshNotifications() async {
    _isCached = false;
    await fetchNotifications();
  }
}

// Provider for notifications
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<NotificationModel>>(
  (ref) => NotificationNotifier(),
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((notification) => !notification.isRead).length;
});
