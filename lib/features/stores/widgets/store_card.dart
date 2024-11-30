import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String location;
  final String deliveryTime;
  final double rating; // Store rating
  final int reviewCount; // Review count

  const StoreCard({
    super.key,
    required this.storeName,
    required this.location,
    required this.deliveryTime,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cardColor, AppColors.cardColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Icon + Store Name
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black.withOpacity(0.2),
                child: const Icon(
                  Icons.storefront,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  storeName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            height: 30,
            thickness: 0.5,
          ),
          // Middle Section: Location + Delivery Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Delivery Time
              Row(
                children: [
                  const Icon(
                    Icons.timer,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    deliveryTime,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bottom Section: Rating and Review Count
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Star Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating
                        ? Icons.star
                        : Icons.star_border, // Full or empty stars
                    color: Colors.amber,
                    size: 24,
                  );
                }),
              ),
              const SizedBox(width: 10),
              // Review Count
              Text(
                "($reviewCount reviews)",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
