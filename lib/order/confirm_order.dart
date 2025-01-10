import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
import 'package:m_n_m/payment/screens/payment_page.dart';

class OrderConfirmationPage extends StatelessWidget {
  final double itemCost;
  final double deliveryCost;
  final double totalPrice;
  final String orderId;

  const OrderConfirmationPage({
    super.key,
    required this.itemCost,
    required this.deliveryCost,
    required this.totalPrice,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Item Cost:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'GHS${itemCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Delivery Cost:',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'GHS${deliveryCost.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Cost:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'GHS${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: CustomButton(
                  title: 'Continue to Checkout',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaystackPaymentPage(
                                orderId: orderId,
                                amoutDue: totalPrice,
                              )))),
            ),
          ],
        ),
      ),
    );
  }
}
