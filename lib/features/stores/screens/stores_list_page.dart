// store_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/features/stores/widgets/store_card.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../providers/store_provider.dart';
import 'store_items_screen.dart';

class StoreListScreen extends ConsumerWidget {
  final String categoryName;

  const StoreListScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsyncValue = ref.watch(storesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text("$categoryName Stores"),
        // Custom AppBar color
      ),
      body: storesAsyncValue.when(
        data: (storeCategories) {
          print(storeCategories);
          // Find the category that matches `categoryName`
          final category = storeCategories.firstWhere(
            (cat) => cat['category'] == categoryName,
            orElse: () => null,
          );

          if (category == null) {
            return const Center(
              child: Text("No stores found in this category"),
            );
          }

          final stores = category['stores'] as List<dynamic>;
          print(stores);
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return GestureDetector(
                    onTap: () {
                      // Navigate to StoreItemsScreen with the store ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoreItemsScreen(
                            storeId: store['_id'],
                            storeName: store['storeName'],
                          ),
                        ),
                      );
                    },
                    child: ShopCard(
                      deliveryTime: '${store['deliveryTime']} mins delivery',
                      rating: 4.0,
                      imageUrl: '',
                      location: store['storeAddress'],
                      shopName: store['storeName'],
                    ));
              },
            ),
          );
        },
        loading: () => const Center(child: NutsActivityIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
