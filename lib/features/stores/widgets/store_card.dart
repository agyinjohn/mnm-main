// import 'package:flutter/material.dart';
// import 'package:m_n_m/constants/global_variables.dart';

// class StoreCard extends StatelessWidget {
//   final String storeName;
//   final String location;
//   final String deliveryTime;
//   final double rating; // Store rating
//   final int reviewCount; // Review count

//   const StoreCard({
//     super.key,
//     required this.storeName,
//     required this.location,
//     required this.deliveryTime,
//     required this.rating,
//     required this.reviewCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColors.cardColor, AppColors.cardColor],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 5,
//             spreadRadius: 3,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Top Section: Icon + Store Name
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.black.withOpacity(0.2),
//                 child: const Icon(
//                   Icons.storefront,
//                   color: Colors.black,
//                   size: 40,
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Text(
//                   storeName,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Divider(
//             color: Colors.grey,
//             height: 30,
//             thickness: 0.5,
//           ),
//           // Middle Section: Location + Delivery Time
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Location
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Colors.redAccent,
//                     size: 28,
//                   ),
//                   const SizedBox(width: 5),
//                   Text(
//                     location,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               // Delivery Time
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.timer,
//                     color: Colors.blueAccent,
//                     size: 28,
//                   ),
//                   const SizedBox(width: 5),
//                   Text(
//                     deliveryTime,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           // Bottom Section: Rating and Review Count
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               // Star Rating
//               Row(
//                 children: List.generate(5, (index) {
//                   return Icon(
//                     index < rating
//                         ? Icons.star
//                         : Icons.star_border, // Full or empty stars
//                     color: Colors.amber,
//                     size: 24,
//                   );
//                 }),
//               ),
//               const SizedBox(width: 10),
//               // Review Count
//               Text(
//                 "($reviewCount reviews)",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';

class ShopCard extends StatelessWidget {
  final String imageUrl;
  final String shopName;
  final String location;
  final String deliveryTime;
  final double rating;

  const ShopCard({
    super.key,
    required this.imageUrl,
    required this.shopName,
    required this.location,
    required this.deliveryTime,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Image with Placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              // Placeholder while the image loads
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              // Fallback if image fails to load
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Shop Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name
                  Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Delivery Time
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        deliveryTime,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: index < rating.toInt()
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
