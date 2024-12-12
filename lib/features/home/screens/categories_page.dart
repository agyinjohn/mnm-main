import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/screens/food_categories_page.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/stores/screens/stores_list_page.dart';

import '../../../common/category_data.dart';
import '../widgets/custom_search_bar.dart';
import '../../stores/screens/dummy_stores_screen.dart';
import 'selected_category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.026),
            const Center(
              child: Text(
                'Categories',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            const Row(
              children: [
                CircleIconButton(icon: Icons.category_outlined),
                SizedBox(width: 10),
                Expanded(child: CustomSearchBar()),
              ],
            ),
            SizedBox(height: size.height * 0.026),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                  crossAxisCount: 2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AvailableStores()));
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => index == 0
                      //         ? StoreListScreen(
                      //             categoryName:
                      //                 GlobalVariables.categoriesList[index])
                      //         : StoreListScreen(
                      //             categoryName:
                      //                 GlobalVariables.categoriesList[index]),
                      //   ),
                      // );
                    },
                    child: CategoryCard(
                      title: category.title,
                      imagePath: category.imagePath,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;

  const CircleIconButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(icon),
    );
  }
}
