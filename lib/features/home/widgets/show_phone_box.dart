import 'package:flutter/material.dart';

Future<String?> showPhoneNumberDialog(BuildContext context) async {
  TextEditingController phoneController = TextEditingController();

  return await showDialog<String>(
    context: context,
    barrierDismissible: false, // Prevent dismissing without input
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Enter Phone Number"),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration:
              const InputDecoration(hintText: "Enter your phone number"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.of(context).pop(phoneController.text);
            },
          ),
        ],
      );
    },
  );
}
