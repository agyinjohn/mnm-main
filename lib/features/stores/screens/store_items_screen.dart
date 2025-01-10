// store_items_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/cart/screens/shop_cart.dart';
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShopCart(storeId: widget.storeId)));
                },
                icon: const Icon(Icons.shopping_cart))
          ],
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
              // print(images);
              // print(item['itemSizes']);
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
                              height: 130,
                              width: 120,
                              child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(
                                        seconds: 20), // Delay of 3 seconds
                                    autoPlayAnimationDuration:
                                        const Duration(seconds: 5),
                                    aspectRatio: 1.0,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1.0,
                                  ),
                                  items: images.map((img) {
                                    // print(img);
                                    return CachedNetworkImage(
                                      imageUrl: '$uri${img['url']}',
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 200,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                    );
                                  }).toList())),
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
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        Icons.star,
                                        size: 16,
                                        color: index < 4.toInt()
                                            ? Colors.amber
                                            : Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    4.toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Price Display Logic
                              Text(
                                item['itemSizes'].length == 1
                                    ? "GHS ${double.parse(item['itemSizes'][0]['price'].toString()).toStringAsFixed(2)}"
                                    : "GHS ${item['itemSizes'].map((e) => double.parse(e['price'].toString())).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)} - GHS ${item['itemSizes'].map((e) => double.parse(e['price'].toString())).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}",
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
