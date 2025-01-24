// store_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/stores/widgets/store_card.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../../home/widgets/error_alert_dialogue.dart';
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
            icon: const Icon(Icons.arrow_back)),
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
                            banner: store['images'][0]['url'],
                            storeId: store['_id'],
                            storeName: store['storeName'],
                          ),
                        ),
                      );
                    },
                    child: ShopCard(
                      deliveryTime: '${store['deliveryTime']} mins delivery',
                      rating: (store['ratings']['totalRatedValue'] as int)
                          .toDouble(),
                      imageUrl: '$uri${store['images'][0]['url']}',
                      location: store['storeAddress'],
                      shopName: store['storeName'],
                    ));
              },
            ),
          );
        },
        loading: () => const Center(child: NutsActivityIndicator()),
        error: (error, stack) {
          Future.delayed(Duration.zero, () {
            if (context.mounted) {
              showErrorDialog(
                context,
                () async {
                  ref.invalidate(storesProvider);
                },
                'Something went wrong while trying to update data!',
              );
            }
          });
          return const SizedBox();
        },
      ),
    );
  }
}
