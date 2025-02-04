import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
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
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        width: 310, // Set the width of the card
        height: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Shop Image with Placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 130,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 130,
                    height: 150,
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 130,
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 50,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Shop Details
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name
                    Text(
                      shopName,
                      overflow: TextOverflow.ellipsis,
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
                        Flexible(
                          child: Text(
                            location,
                            style: const TextStyle(color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Delivery Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            deliveryTime,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) {
                              double starRating = rating - index;
                              return Icon(
                                starRating >= 1
                                    ? Icons.star
                                    : starRating >= 0.5
                                        ? Icons.star_half
                                        : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
