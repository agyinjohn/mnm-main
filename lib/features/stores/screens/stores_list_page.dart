// store_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/stores/providers/new_stores_provider.dart';
import 'package:m_n_m/features/stores/widgets/store_card.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../home/widgets/error_alert_dialogue.dart';
// import '../providers/store_provider.dart';
import 'store_items_screen.dart';

class StoreListScreen extends ConsumerStatefulWidget {
  final String categoryName;

  const StoreListScreen({super.key, required this.categoryName});

  @override
  ConsumerState<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends ConsumerState<StoreListScreen> {
  final bool _isDialogShowing = false;
  @override
  @override
  Widget build(BuildContext context) {
    final storeState = ref.watch(storesProvider);
    final storeNotifier = ref.read(storesProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text("${widget.categoryName} Stores"),
      ),
      body: storeState.when(
        data: (storeCategories) {
          final category = storeCategories.firstWhere(
            (cat) => cat['category'] == widget.categoryName,
            orElse: () => null,
          );

          if (category == null) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      height: 150,
                      image: AssetImage('assets/images/outbound.png')),
                  Center(
                    child: Text(
                      "Your location seems a bit far",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          }

          final stores = category['stores'] as List<dynamic>;

          return ListView.builder(
            padding: const EdgeInsets.all(5.0),
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreItemsScreen(
                        ratings: (store['ratings']['totalRatedValue'] as int)
                            .toDouble(),
                        reviews: store['ratings']['totalPeopleRated'],
                        isOpened: store['open'],
                        banner: store['images']['imageId']['url'],
                        storeId: store['_id'],
                        storeName: store['storeName'],
                        location: store['storeAddress'],
                      ),
                    ),
                  );
                },
                child: ShopCard(
                  deliveryTime: '${store['deliveryTime']} mins delivery',
                  rating:
                      (store['ratings']['totalRatedValue'] as int).toDouble(),
                  imageUrl: '${store['images']['imageId']['url']}',
                  location: store['storeAddress'],
                  shopName: store['storeName'],
                ),
              );
            },
          );
        },
        loading: () => SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Allow pull-to-refresh
          child: Column(
            children: List.generate(10, (index) => _buildShimmerItem()),
          ),
        ),
        error: (error, stack) {
          return RefreshIndicator(
            onRefresh: () async {
              await storeNotifier.refreshStores();
            },
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh even when empty
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 60, color: Colors.red),
                      SizedBox(height: 10),
                      Text(
                        "Something went wrong!",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Pull down to retry.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildShimmerItem() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer for Store Image
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 80, // Adjust based on actual image size
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 16), // Space between image and text
        // Shimmer for Store Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Name
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Location & Delivery Time
              Row(
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 50,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Store Rating
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
