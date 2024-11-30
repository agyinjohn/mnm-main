// store_items_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'item_detail_screen.dart'; // Import your item detail screen
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class StoreItemsScreen extends ConsumerStatefulWidget {
  final String storeId;
  final String storeName;

  const StoreItemsScreen(
      {super.key, required this.storeId, required this.storeName});

  @override
  _StoreItemsScreenState createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends ConsumerState<StoreItemsScreen> {
  late Future<List<Map<String, dynamic>>> _storeItemsFuture;

  Future<List<Map<String, dynamic>>> fetchStoreItems() async {
    final response = await http.get(
      Uri.parse('$uri/auth/stores/items/${widget.storeId}'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load store items");
    }
  }

  @override
  void initState() {
    super.initState();
    _storeItemsFuture = fetchStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text(widget.storeName)),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _storeItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No items found"));
          }

          final storeItems = snapshot.data!;

          return ListView.builder(
            itemCount: storeItems.length,
            itemBuilder: (context, index) {
              final item = storeItems[index];
              final images = item['images'] as List<dynamic>;
              print(item['itemSizes']);
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(
                          item: item,
                          storeId: widget.storeId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Carousel Section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: images.isNotEmpty
                                ? CarouselSlider(
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      autoPlayInterval: const Duration(
                                          seconds: 10), // Delay of 3 seconds
                                      autoPlayAnimationDuration:
                                          const Duration(seconds: 5),
                                      aspectRatio: 1.0,
                                      enlargeCenterPage: true,
                                      viewportFraction: 1.0,
                                    ),
                                    items: images.map((img) {
                                      return Image.network(
                                        '$uri${img['url']}',
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                              width: 100,
                                              height: 100,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.broken_image,
                                              color: Colors.grey[700]);
                                        },
                                      );
                                    }).toList(),
                                  )
                                : Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      color: Colors.grey[300],
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Order Details Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['description'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Price Display Logic
                              Text(
                                item['itemSizes'].length == 1
                                    ? "GHS ${item['itemSizes'][0]['price']}"
                                    : "GHS ${item['itemSizes'].map((e) => e['price']).reduce((a, b) => a < b ? a : b)} - ${item['itemSizes'].map((e) => e['price']).reduce((a, b) => a > b ? a : b)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              // Add to Order Button (Only if length == 1)
                              if (item['itemSizes'].length == 1)
                                ElevatedButton(
                                  onPressed: () {
                                    // Your add-to-order logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Add to Order",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                  // Container(
                  //   margin: const EdgeInsets.symmetric(
                  //       vertical: 8.0, horizontal: 16.0),
                  //   padding: const EdgeInsets.all(12.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.2),
                  //         blurRadius: 10,
                  //         spreadRadius: 2,
                  //         offset: const Offset(0, 5),
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       // Image Section
                  //       if (images.isNotEmpty)
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: Image.network(
                  //             '$uri${images[0]['url']}',
                  //             height: 100,
                  //             width: 100,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       const SizedBox(width: 12),
                  //       // Order Details Section
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               item['name'],
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .titleLarge
                  //                   ?.copyWith(
                  //                     fontWeight: FontWeight.bold,
                  //                   ),
                  //               maxLines: 1,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             const SizedBox(height: 4),
                  //             Text(
                  //               item['description'],
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .bodyMedium
                  //                   ?.copyWith(
                  //                     color: Colors.grey[700],
                  //                   ),
                  //               maxLines: 3,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  );
            },
          );
        },
      ),
    );
  }
}
