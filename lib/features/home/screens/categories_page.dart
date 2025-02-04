import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/auth/screens/my_cart.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';

import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/home/screens/notification_page.dart';
import 'package:m_n_m/features/stores/screens/stores_list_page.dart';
import 'package:m_n_m/models/cart_store_model.dart';
import 'package:m_n_m/order/order_model.dart';
import 'package:m_n_m/providers/notification_provider.dart';

import '../../../common/category_data.dart';

import '../widgets/custom_search_bar.dart';

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
    print('Fetching store items...');

    final storesB = await ref.read(cartProvider.notifier).fetchStores();

    // print(">>>>>>>>");
    // print(jsonEncode(storesB
    //     .map((store) => store.toJson())
    //     .toList())); // Properly encode as JSON
    print(">>>>>>>>>>>>>>>>>>>>>>");

    // print(
    //     'Fetched stores: ${storesB.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');

    // Convert Store objects into a list of JSON-compatible maps
    List<Map<String, dynamic>> storesJson =
        storesB.map((store) => store.toJson()).toList();
    // Convert JSON maps back to StoreCart objects
    print(storesJson[0]);
    List<StoreCart> stores =
        storesJson.map((data) => StoreCart.fromJson(data)).toList();

    // Process stores to get total items and total cost
    List<CartStore> cartStores = processStores(stores);

    // Print results
    for (var cartStore in cartStores) {
      print('Store ID: ${cartStore.storeId}');
      print('Total Items: ${cartStore.totalItemCount}');
      print('Total Cost: \$${cartStore.totalCost.toStringAsFixed(2)}');
      print('-------------------------');
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationUnreadCount = ref.watch(unreadNotificationCountProvider);
    final size = MediaQuery.of(context).size;
    final cartCount = ref.watch(totalCartItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationsPage())),
            child: IconWithBadge(
                icon: Icons.notifications_none_outlined,
                badgeCount: notificationUnreadCount),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartPage())),
            child: IconWithBadge(
                icon: Icons.shopping_cart_outlined, badgeCount: cartCount),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: size.height * 0.01),
            // const Row(
            //   children: [
            //     // CircleIconButton(icon: Icons.category_outlined),
            //     SizedBox(width: 10),
            //     Expanded(child: CustomSearchBar()),
            //   ],
            // ),
            SizedBox(height: size.height * 0.016),
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
                            builder: (context) => StoreListScreen(
                                categoryName:
                                    GlobalVariables.categoriesList[index])),
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
