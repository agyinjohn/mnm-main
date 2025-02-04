import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import '../../../providers/delivery_address_provider.dart';

class MapDeliveryAddressPage extends ConsumerStatefulWidget {
  const MapDeliveryAddressPage({super.key});

  @override
  ConsumerState<MapDeliveryAddressPage> createState() =>
      _MapDeliveryAddressPageState();
}

class _MapDeliveryAddressPageState
    extends ConsumerState<MapDeliveryAddressPage> {
  CameraPosition? _initialCameraPosition;
  bool _isLoading = true;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to get current location."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAddress = ref.watch(deliveryAddressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Delivery Address"),
        backgroundColor: AppColors.onPrimaryColor,
      ),
      body: _isLoading
          ? const Center(child: NutsActivityIndicator())
          : _initialCameraPosition == null
              ? const Center(
                  child: Text("Unable to determine initial position."),
                )
              : GoogleMap(
                  onTap: (LatLng location) async {
                    // Set the delivery address and show confirmation dialog

                    setState(() {
                      _selectedLocation = location; // Update marker position
                    });
                    await _showAddressConfirmationDialog(
                        context, ref, location);
                  },
                  initialCameraPosition: _initialCameraPosition!,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected-location'),
                            position: _selectedLocation!,
                          ),
                        }
                      : {},
                ),
    );
  }

  // Future<void> _showAddressConfirmationDialog(
  //   BuildContext context,
  //   WidgetRef ref,
  //   LatLng location,
  // ) async {
  //   final deliveryAddress = ref.read(deliveryAddressProvider);
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       title: const Text(
  //         "Confirm Delivery Address",
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       content: deliveryAddress != null
  //           ? Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 if (deliveryAddress.streetName.isNotEmpty)
  //                   Text(
  //                     "Street: ${deliveryAddress.streetName}",
  //                     style:
  //                         const TextStyle(fontSize: 16, color: Colors.black87),
  //                   ),
  //                 if (deliveryAddress.subLocality.isNotEmpty)
  //                   Text(
  //                     "Sublocality: ${deliveryAddress.subLocality}",
  //                     style:
  //                         const TextStyle(fontSize: 16, color: Colors.black54),
  //                   ),
  //               ],
  //             )
  //           : const Text(
  //               "Unable to fetch address details.",
  //               style: TextStyle(fontSize: 16, color: Colors.redAccent),
  //             ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text(
  //             "Cancel",
  //             style: TextStyle(
  //               color: Colors.grey,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text("Delivery address set successfully!"),
  //                 duration: Duration(seconds: 2),
  //               ),
  //             );
  //             Navigator.of(context).pop();
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColors.buttonHoverColor,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //           ),
  //           child: const Text(
  //             "Confirm",
  //             style: TextStyle(
  //               color: AppColors.buttonTextColor,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Future<void> _showAddressConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    LatLng location,
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Are you sure you want to set this as your delivery address?",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              "Latitude: ${location.latitude.toStringAsFixed(5)}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              "Longitude: ${location.longitude.toStringAsFixed(5)}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
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
            onPressed: () {
              ref.read(deliveryAddressProvider.notifier).setDeliveryAddress(
                    context: context,
                    latitude: location.latitude,
                    longitude: location.longitude,
                  );
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
}
