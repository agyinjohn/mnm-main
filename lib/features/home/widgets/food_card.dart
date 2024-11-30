import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../constants/global_variables.dart';

class FoodCard extends StatelessWidget {
  final imageUrl, newAmount;
  const FoodCard({super.key, required this.imageUrl, required this.newAmount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        height: 146,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            Container(
              height: 146,
              width: 146,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.cardColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Classic Fried Chicken Meal Combo with Coca Cola',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      children: [
                        Text('Rating: ', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 2),
                        Icon(Icons.star_outlined,
                            color: AppColors.primaryColor, size: 16),
                        Icon(Icons.star_outlined,
                            color: AppColors.primaryColor, size: 16),
                        Icon(Icons.star_outlined,
                            color: AppColors.primaryColor, size: 16),
                        Icon(Icons.star_outlined,
                            color: AppColors.primaryColor, size: 16),
                        Icon(Icons.star_outlined,
                            color: Colors.black, size: 16),
                        SizedBox(width: 2),
                        Text('4.0', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const Row(
                      children: [
                        Icon(Icons.business, size: 16),
                        SizedBox(width: 4),
                        Text('KFC (Kentucky Fried Chicken)',
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('\$50.00',
                            style: TextStyle(
                                fontSize: 9,
                                decoration: TextDecoration.lineThrough)),
                        const SizedBox(width: 6),
                        Text(
                          '\$ $newAmount',
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.primaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
