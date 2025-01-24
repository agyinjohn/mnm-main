import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m_n_m/providers/delivery_address_provider.dart';

import '../stores_api_service.dart';

final locationProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception("Location services are disabled");
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception("Location permissions are denied");
    }
  }

  return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
    distanceFilter: 0,
    accuracy: LocationAccuracy.high,
  ));
});

final storesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  // final location = await ref.watch(locationProvider.future);
  final deliveryAddress = ref.watch(deliveryAddressProvider);
  return StoreService()
      .fetchStores(deliveryAddress!.longitude, deliveryAddress.latitude);
});
