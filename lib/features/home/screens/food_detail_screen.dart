// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/global_variables.dart';

class FoodDetailsPage extends ConsumerStatefulWidget {
  const FoodDetailsPage({
    super.key,
    required this.item,
    required this.storeId,
  });
  final Map<String, dynamic> item;
  final String storeId;
  @override
  ConsumerState<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends ConsumerState<FoodDetailsPage> {
  bool isExpanded = false; // Track whether the full text is displayed
  late Widget sizeSelectionWidget;
  final String description =
      "Enjoy a satisfying meal with our Classic Fried Chicken Combo, featuring two pieces of golden, crispy fried chicken, a side of fragrant jollof rice and a refreshing Coca-Cola to complete the experience."; // Full description

  String? selectedSize;
  String? selectedSizeId;
  double selectedSizePrice = 0.0;
  Map<String, int> addOnQuantities = {}; // Stores quantity for each add-on
  int quantity = 1;
  bool isAddingToCart = false;
  double calculateTotalPrice() {
    double totalAddOnPrice = addOnQuantities.entries.fold(
      0.0,
      (sum, entry) {
        final addOn = widget.item['attributes']['Add-ons']
            .firstWhere((addOn) => addOn['name'] == entry.key);
        double addOnPrice = addOn['price'] is String
            ? double.parse(addOn['price'])
            : addOn['price'].toDouble();
        return sum + (addOnPrice * entry.value.toDouble());
      },
    );
    return (selectedSizePrice * quantity.toDouble()) + totalAddOnPrice;
  }

  void addToCart() async {
    if (selectedSize == null) return;

    // Prepare add-ons for adding to the cart
    try {
      setState(() {
        isAddingToCart = true;
      });
      dynamic selectedAddOns = addOnQuantities.entries
          .where((entry) => entry.value > 0)
          .map((entry) {
        final addOn = widget.item['attributes']['Add-ons']
            .firstWhere((addOn) => addOn['name'] == entry.key);
        return {
          "name": addOn['name'],
          "price": double.parse(addOn['price'].toString()),
          "quantity": entry.value,
        };
      }).toList();

      await ref.read(cartProvider.notifier).addItem(
            context,
            selectedSizeId!, // Assuming 'id' is the unique identifier for the product
            quantity,
            '${widget.item['name']}',
            selectedSizePrice,
            widget.storeId,
            selectedAddOns,
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
  Widget build(BuildContext context) {
    final sizes = widget.item['itemSizes'] as List<dynamic>;
    final addOns = widget.item['attributes']['Add-ons'] as List<dynamic>? ?? [];
    if (sizes.length == 1) {
      // Automatically select the only available size
      final size = sizes.first;
      selectedSize = size['name'];
      selectedSizePrice = size['price'] is String
          ? double.parse(size['price'])
          : size['price'].toDouble();
      selectedSizeId = size["_id"];

      sizeSelectionWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Price: GHC ${selectedSizePrice.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      );
    } else {
      sizeSelectionWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Size (select one):",
              style: Theme.of(context).textTheme.titleMedium),
          ...sizes.map((size) {
            return RadioListTile<String>(
              title: Text("${size['name']} (GHC${size['price'].toDouble()})"),
              value: size['name'],
              groupValue: selectedSize,
              onChanged: (value) {
                setState(() {
                  selectedSize = value;
                  selectedSizePrice = size['price'] is String
                      ? double.parse(size['price'])
                      : size['price'].toDouble();
                  selectedSizeId = size["_id"];
                });
              },
            );
          }), // Convert Iterable to List<Widget>
        ],
      );
    }
    print('>>>>>>>>>>>>>>>>>>');
    print(sizes.length);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Top Carousel
          // CarouselSlider(
          //   items: [
          //     Image.network(
          //         'https://via.placeholder.com/400x300', // Replace with your image URLs
          //         fit: BoxFit.cover),
          //     Image.network(
          //         'https://via.placeholder.com/400x300', // Replace with your image URLs
          //         fit: BoxFit.cover),
          //     Image.network(
          //         'https://via.placeholder.com/400x300', // Replace with your image URLs
          //         fit: BoxFit.cover),
          //   ],
          //   options: CarouselOptions(
          //     height: 250,
          //     enableInfiniteScroll: true,
          //     autoPlay: true,
          //     enlargeCenterPage: true,
          //   ),
          // ),
          if ((widget.item['images'] as List<dynamic>).isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 10),
                height: 270,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
              items:
                  (widget.item['images'] as List<dynamic>).map<Widget>((img) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Image.network(
                    '${img['url']}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[100]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey[100],
                          height: 100,
                          width: double.infinity,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),

          // Animated Bottom Section
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.98,
            builder: (context, scrollController) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              widget.item['name']
                                  .replaceAll(RegExp(r'\s+'),
                                      ' ') // Replace multiple spaces/newlines with one space
                                  .trim(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rating Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Rating:",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "4.0",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isExpanded
                            ? widget.item['description']
                                .replaceAll(RegExp(r'\s+'),
                                    ' ') // Replace multiple spaces/newlines with one space
                                .trim()
                            : widget.item['description'].toString().length > 100
                                ? "${widget.item['description'].substring(0, 100)}..." // Limit text
                                : widget.item['description'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle "Read more"
                          setState(() {
                            isExpanded = !isExpanded; // Toggle expansion
                          });
                        },
                        child: Text(
                          isExpanded ? "Read less" : "Read more",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 10),
                      sizeSelectionWidget,
                      const SizedBox(height: 10),
                      // Text("Select Size(select one):",
                      //     style: Theme.of(context).textTheme.titleMedium),
                      // ...sizes.map((size) {
                      //   return RadioListTile<String>(
                      //     title: Text(
                      //         "${size['name']} (GHS${size['price'].toDouble()})"),
                      //     value: size['name'],
                      //     groupValue: selectedSize,
                      //     onChanged: (value) {
                      //       print(value);
                      //       setState(() {
                      //         selectedSize = value;
                      //         selectedSizePrice = size['price'] is String
                      //             ? double.parse(size['price'])
                      //             : size['price'].toDouble();
                      //         selectedSizeId = size["_id"];
                      //         // print(selectedSizePrice);
                      //       });
                      //     },
                      //   );
                      // }),
                      if (addOns.isNotEmpty) ...[
                        Text("Add-ons:",
                            style: Theme.of(context).textTheme.titleMedium),
                        ...addOns.map((addOn) {
                          final addOnName = addOn['name'];
                          final addOnPrice = addOn['price'];
                          final addOnQuantity = addOnQuantities[addOnName] ?? 0;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$addOnName: GHC ${double.tryParse(addOnPrice)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: addOnQuantity > 0
                                        ? () {
                                            setState(() {
                                              addOnQuantities[addOnName] =
                                                  addOnQuantity - 1;
                                            });
                                          }
                                        : null,
                                  ),
                                  Text('$addOnQuantity',
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        addOnQuantities[addOnName] =
                                            addOnQuantity + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ],

                      // Quantity Section
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Decrease quantity
                                  quantity > 1
                                      ? setState(() => quantity--)
                                      : null;
                                },
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                '$quantity', // Replace with the actual quantity
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Increase quantity
                                  setState(() => quantity++);
                                },
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Price',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            " GHC ${calculateTotalPrice().toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Add to cart action
                            addToCart();
                          },
                          child: isAddingToCart
                              ? const NutsActivityIndicator()
                              : const Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



// item_detail_screen.dart
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // import 'package:m_n_m/common/widgets/cusztom_button.dart';
// import 'package:m_n_m/constants/global_variables.dart';

// import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../cart/providers/cart_provider.dart';

// class ItemDetailScreen extends ConsumerStatefulWidget {
//   final Map<String, dynamic> item;
//   final String storeId;

//   const ItemDetailScreen(
//       {super.key, required this.item, required this.storeId});

//   @override
//   _ItemDetailScreenState createState() => _ItemDetailScreenState();
// }

// class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
//   String? selectedSize;
//   String? selectedSizeId;
//   double selectedSizePrice = 0.0;
//   Map<String, int> addOnQuantities = {}; // Stores quantity for each add-on
//   int quantity = 1;
//   bool isAddingToCart = false;
//   double calculateTotalPrice() {
//     double totalAddOnPrice = addOnQuantities.entries.fold(
//       0.0,
//       (sum, entry) {
//         final addOn = widget.item['attributes']['Add-ons']
//             .firstWhere((addOn) => addOn['name'] == entry.key);
//         double addOnPrice = addOn['price'] is String
//             ? double.parse(addOn['price'])
//             : addOn['price'].toDouble();
//         return sum + (addOnPrice * entry.value.toDouble());
//       },
//     );
//     return (selectedSizePrice * quantity.toDouble()) + totalAddOnPrice;
//   }

//   void addToCart() async {
//     if (selectedSize == null) return;

//     // Prepare add-ons for adding to the cart
//     try {
//       setState(() {
//         isAddingToCart = true;
//       });
//       dynamic selectedAddOns = addOnQuantities.entries
//           .where((entry) => entry.value > 0)
//           .map((entry) {
//         final addOn = widget.item['attributes']['Add-ons']
//             .firstWhere((addOn) => addOn['name'] == entry.key);
//         return {
//           "name": addOn['name'],
//           "price": double.parse(addOn['price'].toString()),
//           "quantity": entry.value,
//         };
//       }).toList();

//       await ref.read(cartProvider.notifier).addItem(
//             selectedSizeId!, // Assuming 'id' is the unique identifier for the product
//             quantity,
//             '${widget.item['name']}-$selectedSize',
//             selectedSizePrice,
//             widget.storeId,
//             selectedAddOns,
//           );

//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('${widget.item['name']} added to cart!')),
//       // );
//     } catch (er) {
//       print(er.toString());
//     } finally {
//       setState(() {
//         isAddingToCart = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sizes = widget.item['itemSizes'] as List<dynamic>;
//     final addOns = widget.item['attributes']['Add-ons'] as List<dynamic>? ?? [];

//     return Scaffold(
//       extendBody: true,
//       // appBar: AppBar(
//       //     backgroundColor: Colors.transparent,
//       //     title: Text(widget.item['name'])),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if ((widget.item['images'] as List<dynamic>).isNotEmpty)
//               CarouselSlider(
//                 options: CarouselOptions(
//                   autoPlay: true,
//                   autoPlayInterval: const Duration(seconds: 10),
//                   height: 200,
//                   viewportFraction: 1.0,
//                   enableInfiniteScroll: true,
//                   autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                 ),
//                 items:
//                     (widget.item['images'] as List<dynamic>).map<Widget>((img) {
//                   return ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10)),
//                     child: Image.network(
//                       '$uri${img['url']}',
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Shimmer.fromColors(
//                           baseColor: Colors.grey[300]!,
//                           highlightColor: Colors.grey[100]!,
//                           child: Container(
//                             color: Colors.grey[300],
//                             height: 100,
//                             width: double.infinity,
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           width: double.infinity,
//                           height: 300,
//                           color: Colors.grey[300],
//                           child: const Icon(
//                             Icons.broken_image,
//                             size: 50,
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             // Image.network(
//             //   '$uri${widget.item['images'][0]['url']}',
//             //   height: 150,
//             //   width: double.infinity,
//             //   fit: BoxFit.cover,
//             // ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Name", style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 5),
//                   Text(
//                     widget.item['name']
//                         .replaceAll(RegExp(r'\s+'),
//                             ' ') // Replace multiple spaces/newlines with one space
//                         .trim(),
//                     // maxLines: 1,
//                     style: const TextStyle(fontSize: 18),
//                     textAlign: TextAlign.justify,
//                     softWrap:
//                         true, // Ensures the text wraps within the container
//                     overflow: TextOverflow.visible,
//                   ),
//                   const SizedBox(height: 10),
//                   Text("Description",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   const SizedBox(height: 5),
//                   SizedBox(
//                       width: double.infinity,
//                       child: Text(
//                         widget.item['description']
//                             .replaceAll(RegExp(r'\s+'),
//                                 ' ') // Replace multiple spaces/newlines with one space
//                             .trim(),
//                         // maxLines: 1,
//                         style: const TextStyle(),
//                         textAlign: TextAlign.justify,
//                         softWrap:
//                             true, // Ensures the text wraps within the container
//                         overflow: TextOverflow.visible,
//                       )),
//                   const SizedBox(height: 10),
//                   Text("Select Size(select one):",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   ...sizes.map((size) {
//                     return RadioListTile<String>(
//                       title: Text(
//                           "${size['name']} (GHS${size['price'].toDouble()})"),
//                       value: size['name'],
//                       groupValue: selectedSize,
//                       onChanged: (value) {
//                         print(value);
//                         setState(() {
//                           selectedSize = value;
//                           selectedSizePrice = size['price'] is String
//                               ? double.parse(size['price'])
//                               : size['price'].toDouble();
//                           selectedSizeId = size["_id"];
//                           // print(selectedSizePrice);
//                         });
//                       },
//                     );
//                   }),
//                   const Divider(),

//                   // Add-ons with quantity control
//                   Text("Add-ons:",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   ...addOns.map((addOn) {
//                     final addOnName = addOn['name'];
//                     final addOnPrice = addOn['price'];
//                     final addOnQuantity = addOnQuantities[addOnName] ?? 0;

//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "$addOnName (GHS${double.tryParse(addOnPrice)})",
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove),
//                               onPressed: addOnQuantity > 0
//                                   ? () {
//                                       setState(() {
//                                         addOnQuantities[addOnName] =
//                                             addOnQuantity - 1;
//                                       });
//                                     }
//                                   : null,
//                             ),
//                             Text('$addOnQuantity',
//                                 style: const TextStyle(fontSize: 16)),
//                             IconButton(
//                               icon: const Icon(Icons.add),
//                               onPressed: () {
//                                 setState(() {
//                                   addOnQuantities[addOnName] =
//                                       addOnQuantity + 1;
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   }),
//                   const Divider(),

//                   // Quantity Selector
//                   Row(
//                     children: [
//                       const Text("Quantity:", style: TextStyle(fontSize: 16)),
//                       IconButton(
//                         icon: const Icon(Icons.remove),
//                         onPressed: quantity > 1
//                             ? () => setState(() => quantity--)
//                             : null,
//                       ),
//                       Text('$quantity', style: const TextStyle(fontSize: 16)),
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () => setState(() => quantity++),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Total Price Display
//                   Text(
//                     "Total Price: GHS${calculateTotalPrice().toStringAsFixed(2)}",
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 16),

//                   // Add to Cart Button
//                   // CustomButton(
//                   //   title: 'Add to cart',
//                   //   onTap: () => selectedSize != null
//                   //       ? () {
//                   //           // Here, you could add the item with selected options to the cart
//                   //           addToCart();
//                   //         }
//                   //       : null,
//                   // ),
//                   Center(
//                     child: SizedBox(
//                       width: 250,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: AppColors.primaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(5), // Rounded corners
//                           ),
//                         ),
//                         onPressed: selectedSize != null
//                             ? () {
//                                 // Here, you could add the item with selected options to the cart
//                                 addToCart();
//                               }
//                             : null,
//                         child: isAddingToCart
//                             ? const NutsActivityIndicator()
//                             : const Text("Add to Cart"),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Item Sizes
//           ],
//         ),
//       ),
//     );
//   }
// }
