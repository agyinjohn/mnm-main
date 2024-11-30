import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userId = "";
  String name = "";
  String email = "";
  String phoneNumber = "";
  String role = "";
  DateTime createdAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token');

    if (token != null) {
      try {
        // Decode the JWT token
        final jwt = JwtDecoder.decode(token);
        setState(() {
          userId = jwt['_id'];
          name = jwt['name'];
          email = jwt['email'];
          phoneNumber = jwt['phoneNumber'];
          role = jwt['role'];
          createdAt = DateTime.parse(jwt['created_at']);
        });
      } catch (e) {
        print('Error decoding token: $e');
      }
    }
  }

  void _logout() async {
    // Clear the token and navigate to the login page or home
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-auth-token');

    // Navigate back to login or home page
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.cardColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            _buildInfoRow("Email", email),
            _buildInfoRow("Phone", phoneNumber),
            _buildInfoRow("Role", role),
            _buildInfoRow("Account Created",
                createdAt.toLocal().toString().split(' ')[0]),
            const SizedBox(height: 30),
            _buildButton(
              context,
              label: "Add Payment Option",
              icon: Icons.payment,
              onPressed: () {
                // Navigate to Add Payment Option screen
              },
            ),
            const SizedBox(
              height: 10,
            ),
            _buildButton(
              context,
              label: "Logout",
              icon: Icons.logout,
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              AppColors.primaryColor, // Change button color to light green
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Reduce the border radius
          ),
          elevation: 3, // Add a slight elevation for a subtle shadow
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold), // Make text slightly bolder
        ),
        onPressed: onPressed,
      ),
    );
  }
}
