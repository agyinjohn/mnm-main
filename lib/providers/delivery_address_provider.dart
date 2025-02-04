import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m_n_m/features/home/screens/error_page.dart';

import '../models/delivery_address_model.dart';

final deliveryAddressProvider =
    StateNotifierProvider<DeliveryAddressNotifier, DeliveryAddress?>(
  (ref) => DeliveryAddressNotifier(),
);

class DeliveryAddressNotifier extends StateNotifier<DeliveryAddress?> {
  DeliveryAddressNotifier() : super(null);

  Future<void> setDeliveryAddress({
    required double latitude,
    required double longitude,
    required BuildContext context,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException("Network request timed out");
      });

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        final address = DeliveryAddress(
          latitude: latitude,
          longitude: longitude,
          streetName: placemark.street ?? "Unknown Street",
          subLocality: placemark.subLocality ?? "Unknown Sublocality",
        );
        state = address; // Update the state
      }
    } on TimeoutException catch (t) {
      debugPrint("Timeout Exception: $t");
      _handleError(context, "Request timed out. Please try again.");
    } on PlatformException catch (p) {
      debugPrint("Platform Exception: $p");
      if (p.code == 'PERMISSION_DENIED') {
        _handleError(
            context, "Location permissions are denied. Please enable them.");
      } else if (p.code == 'LOCATION_SERVICE_DISABLED') {
        _handleError(
            context, "Location services are disabled. Please enable them.");
      } else {
        _handleError(context, "Error fetching location. Try again.");
      }
    } catch (e) {
      debugPrint("Unknown Error: $e");
      _handleError(context, "Failed to fetch delivery address. Try again.");
    }
  }

  Future<void> setCurrentLocation(BuildContext context) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await setDeliveryAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        context: context,
      );
    } catch (e) {
      debugPrint("Error fetching current location: $e");
      _handleError(context, "Failed to fetch current location. Try again.");
    }
  }

  void _handleError(BuildContext context, String message) {
    debugPrint("Error: $message");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (e) => ErrorPage(errorMessage: message)),
    );
  }
}

// class DeliveryAddressNotifier extends StateNotifier<DeliveryAddress?> {
//   DeliveryAddressNotifier() : super(null);

//   Future<void> setDeliveryAddress({
//     required double latitude,
//     required double longitude,
//     required BuildContext context,
//   }) async {
//     try {
//       // Fetch placemarks from coordinates
//       final placemarks = await placemarkFromCoordinates(
//         latitude,
//         longitude,
//       ).timeout(
//         const Duration(seconds: 60),
//         onTimeout: () {
//           throw TimeoutException("Network request timed out");
//         },
//       );

//       if (placemarks.isNotEmpty) {
//         final placemark = placemarks[0];
//         final address = DeliveryAddress(
//           latitude: latitude,
//           longitude: longitude,
//           streetName: placemark.street ?? "Unknown Street",
//           subLocality: placemark.subLocality ?? "Unknown Sublocality",
//         );
//         state = address; // Update the state
//         debugPrint("Address set successfully: $address");
//       } else {
//         throw Exception("No placemarks found for the given coordinates.");
//       }
    // } on TimeoutException catch (t) {
    //   debugPrint("Timeout Exception: $t");
    //   _handleError(context, "Request timed out. Please try again.");
    // } on PlatformException catch (p) {
    //   debugPrint("Platform Exception: $p");
    //   if (p.code == 'PERMISSION_DENIED') {
    //     _handleError(
    //         context, "Location permissions are denied. Please enable them.");
    //   } else if (p.code == 'LOCATION_SERVICE_DISABLED') {
    //     _handleError(
    //         context, "Location services are disabled. Please enable them.");
    //   } else {
    //     _handleError(context, "Error fetching location. Try again.");
    //   }
    // } catch (e) {
    //   debugPrint("Unknown Error: $e");
    //   _handleError(context, "Failed to fetch delivery address. Try again.");
    // }
//   }

//   Future<void> setCurrentLocation(BuildContext context) async {
//     try {
//       // Check location permissions
//       final hasPermission = await _handleLocationPermission(context);
//       if (!hasPermission) return;

//       // Get current position
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // Set delivery address using the current location
//       await setDeliveryAddress(
//         latitude: position.latitude,
//         longitude: position.longitude,
//         context: context,
//       );
//     } catch (e) {
//       debugPrint("Error fetching current location: $e");
//       _handleError(context, "Failed to fetch current location. Try again.");
//     }
//   }

//   Future<bool> _handleLocationPermission(BuildContext context) async {
//     LocationPermission permission;

//     // Check if location services are enabled
//     final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       _handleError(
//           context, "Location services are disabled. Please enable them.");
//       return false;
//     }

//     // Check location permission
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _handleError(context, "Location permissions are denied.");
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _handleError(context,
//           "Location permissions are permanently denied. Please enable them in the app settings.");
//       return false;
//     }

//     return true;
//   }

 

