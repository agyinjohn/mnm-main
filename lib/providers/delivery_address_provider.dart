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
      ).timeout(const Duration(seconds: 30), onTimeout: () {
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
      print(t);
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const ErrorPage()));
    } on PlatformException catch (p) {
      print(p);
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const ErrorPage()));
    } catch (e) {
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const ErrorPage()));
      print("Error fetching address details: $e");
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
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const ErrorPage()));
      print("Error fetching current location: $e");
    }
  }
}
