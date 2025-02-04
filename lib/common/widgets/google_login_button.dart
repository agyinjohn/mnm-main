import 'package:flutter/material.dart';

class GoogleSignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const GoogleSignUpButton(
      {super.key, required this.onPressed, this.text = "Sign Up with Google"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Google button style
        foregroundColor: Colors.black, // Text color
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
              color: Colors.grey), // Border for better visibility
        ),
        elevation: 2, // Slight elevation for a modern look
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/g.png', // Ensure you have a Google logo in assets
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
