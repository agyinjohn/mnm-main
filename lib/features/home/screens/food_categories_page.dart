import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../constants/global_variables.dart';
import '../widgets/custom_search_bar.dart';
import 'food_details.dart';

class FoodCategoriesPage extends StatelessWidget {
  final String categoryName;
  final List items; // List of items for the selected category

  const FoodCategoriesPage({
    super.key,
    required this.categoryName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: AppColors.pageHeaderColor,
            height: size.height * 0.22,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.06),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(IconlyLight.arrow_left_2, size: 16),
                        const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: size.width * 0.25),
                        Center(
                          child: Text(
                            categoryName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.search),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.022),
                  const CustomSearchBar(),
                ],
              ),
            ),
          ),
          // The content section below the header
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodDetailsScreen(
                            imageUrl: '',

                            foodName: '', // Pass the list of items
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.6),
                      child: items[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
