// store_items_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/features/cart/screens/shop_cart.dart';
import 'package:m_n_m/features/home/screens/food_detail_screen.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/home/widgets/error_alert_dialogue.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'item_detail_screen.dart'; // Import your item detail screen
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class StoreItemsScreen extends ConsumerStatefulWidget {
  final String storeId;
  final String storeName;
  final String banner;
  final String location;
  final bool isOpened;
  final double ratings;
  final int reviews;
  const StoreItemsScreen(
      {super.key,
      required this.location,
      required this.storeId,
      required this.storeName,
      required this.isOpened,
      required this.reviews,
      required this.ratings,
      required this.banner});

  @override
  _StoreItemsScreenState createState() => _StoreItemsScreenState();
}

class _StoreItemsScreenState extends ConsumerState<StoreItemsScreen> {
  String? selectedSize;
  String? selectedSizeId;
  bool isAddingToCart = false;
  late Future<List<Map<String, dynamic>>> _storeItemsFuture;

  Future<List<Map<String, dynamic>>> fetchStoreItems() async {
    final response = await http.get(
      Uri.parse('$uri/auth/store-items/${widget.storeId}'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to load store items");
    }
  }

  void addToCart(double selectedSizePrice, String itemName) async {
    if (selectedSize == null) return;

    // Prepare add-ons for adding to the cart
    try {
      setState(() {
        isAddingToCart = true;
      });

      await ref.read(cartProvider.notifier).addItem(
        context,
        selectedSizeId!, // Assuming 'id' is the unique identifier for the product
        1,
        itemName,
        selectedSizePrice,
        widget.storeId,
        [],
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('${widget.item['name']} added to cart!')),
      // );
    } catch (er) {
      print(er.toString());
    } finally {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _storeItemsFuture = fetchStoreItems();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = ref.watch(storeItemCountProvider(widget.storeId));
    print(widget.banner);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Transparent AppBar
              CachedNetworkImage(
                height: 220,
                width: double.infinity,
                imageUrl: widget.banner, // Replace with your shop image URL
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              // Body Content Section
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for body
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _storeItemsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: NutsActivityIndicator());
                      } else if (snapshot.hasError) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showErrorDialog(context, () {
                            setState(() {
                              _storeItemsFuture =
                                  fetchStoreItems(); // Refetch the data
                            });
                          }, 'Something went wrong while updating the data');
                        });

                        return const SizedBox();
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No items found"));
                      }

                      final storeItems = snapshot.data!;
                      // print(storeItems);
                      return ListView.builder(
                        itemCount: storeItems.length,
                        itemBuilder: (context, index) {
                          final item = storeItems[index];

                          final images = item['images'] as List<dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetailsPage(
                                          item: item,
                                          storeId: widget.storeId,
                                        )
                                    // ItemDetailScreen(
                                    //   item: item,
                                    //   storeId: widget.storeId,
                                    // ),
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
                                          autoPlayInterval:
                                              const Duration(seconds: 20),
                                          autoPlayAnimationDuration:
                                              const Duration(seconds: 5),
                                          aspectRatio: 1.0,
                                          enlargeCenterPage: true,
                                          viewportFraction: 1.0,
                                        ),
                                        items: images.map((img) {
                                          return CachedNetworkImage(
                                            imageUrl: '${img['url']}',
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Order Details Section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          maxLines: 2,
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
                                        const SizedBox(height: 3),
                                        if (item['itemSizes'].length == 1) ...[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "GHC ${double.parse(item['itemSizes'][0]['price'].toString()).toStringAsFixed(2)}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (!(item['attributes']
                                                          ?.containsKey(
                                                              'Add-ons') ==
                                                      true &&
                                                  (item['attributes']
                                                                  ?['Add-ons']
                                                              as List?)
                                                          ?.isNotEmpty ==
                                                      true))
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Add to order logic
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        GlobalVariables
                                                            .secondaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ] else
                                          Text(
                                            "GHC ${item['itemSizes'].map((e) => double.parse(e['price'].toString())).reduce((a, b) => a < b ? a : b).toStringAsFixed(2)} - GHC ${item['itemSizes'].map((e) => double.parse(e['price'].toString())).reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 135,
            left: 16,
            right: 16,
            child: Card(
              color: AppColors.cardColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            widget.storeName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 75,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              color: Colors.grey),
                          child: Center(
                            child: Text(
                              widget.isOpened ? 'Serving Now' : 'Not Serving',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.location,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${widget.ratings}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text('${widget.reviews} reviews')
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopCart(
                            storeId: widget.storeId,
                            storeName: widget.storeName,
                          ))),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconWithBadge(
                    icon: Icons.shopping_cart_outlined, badgeCount: itemCount),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//provost -isaac - Amidu