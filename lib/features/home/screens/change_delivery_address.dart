import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/constants/utils.dart';
import 'package:m_n_m/features/home/screens/delivery_address_map.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../../providers/delivery_address_provider.dart';

class DeliveryAddressPage extends ConsumerStatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  ConsumerState<DeliveryAddressPage> createState() =>
      _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends ConsumerState<DeliveryAddressPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final deliveryAddress = ref.watch(deliveryAddressProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery Address",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.onPrimaryColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MapDeliveryAddressPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.buttonHoverColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Change Delivery Address",
                    style: TextStyle(
                        fontSize: 16, color: AppColors.buttonTextColor),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // _showAddressConfirmationDialog(context, ref);
                    setState(() {
                      isLoading = true;
                    });
                    await ref
                        .read(deliveryAddressProvider.notifier)
                        .setCurrentLocation(context);
                    Navigator.pop(context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.buttonHoverColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Use Current Location",
                    style: TextStyle(
                        fontSize: 16, color: AppColors.buttonTextColor),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white.withOpacity(0.4),
              child: const NutsActivityIndicator(),
            )
        ],
      ),
    );
  }
}

Future<void> _showAddressConfirmationDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Text(
        "Confirm Delivery Address",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Are you sure you want to use your current locatio as delivery address?",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Dismiss dialog without setting address
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await ref
                .read(deliveryAddressProvider.notifier)
                .setCurrentLocation(context);
            Navigator.of(context).pop(); // Dismiss dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Delivery address set successfully!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonHoverColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            "Confirm",
            style: TextStyle(
              color: AppColors.buttonTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
