import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../constants/global_variables.dart';

import '../widgets/custom_search_bar.dart';

class SelectedCategoryScreen extends StatelessWidget {
  final String categoryName;
  final List items; // List of items for the selected category

  const SelectedCategoryScreen({
    super.key,
    required this.categoryName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                        SizedBox(width: size.width * 0.21),
                        Center(
                          child: Text(
                            categoryName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.022),
                  const CustomSearchBar(),
                  // SizedBox(height: size.height * 0.008),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12),
                itemCount: items.length,
                itemBuilder: (context, index) => items[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
