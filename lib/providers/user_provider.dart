import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(User(
            id: '',
            name: '',
            email: '',
            password: '',
            address: '',
            role: '',
            token: '',
            phoneNumber: ''));

  // Function to set user from JSON data
  void setUser(String user) {
    state = User.fromJson(user);
  }

  // Function to set user from a User model
  void setUserFromModel(User user) {
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
