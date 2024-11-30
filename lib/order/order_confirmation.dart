import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Order")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text("Choose Delivery Address"),
              onPressed: () {
                // Open map or address selector
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Place order and navigate to the success page
              },
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
