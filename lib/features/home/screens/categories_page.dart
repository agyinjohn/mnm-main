import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/screens/food_categories_page.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/stores/screens/stores_list_page.dart';

import '../../../common/category_data.dart';
import '../../cart/providers/cart_provider.dart';
import '../widgets/custom_search_bar.dart';
import 'selected_category.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  Future<void> getCartItems() async {
    print('fetching store items');
    final stores = await ref.read(cartProvider.notifier).fetchStores();
    print(
        'fetched stores: ${stores.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  crossAxisCount: 3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => index == 0
                              ? StoreListScreen(
                                  categoryName:
                                      GlobalVariables.categoriesList[index])
                              : StoreListScreen(
                                  categoryName:
                                      GlobalVariables.categoriesList[index]),
                        ),
                      );
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
