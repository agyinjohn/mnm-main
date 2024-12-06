// item_detail_screen.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:m_n_m/common/widgets/cusztom_button.dart';
import 'package:m_n_m/constants/global_variables.dart';

import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../cart/providers/cart_provider.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> item;
  final String storeId;

  const ItemDetailScreen(
      {super.key, required this.item, required this.storeId});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
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
            selectedSizeId!, // Assuming 'id' is the unique identifier for the product
            quantity,
            '${widget.item['name']}-$selectedSize',
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

    return Scaffold(
      extendBody: true,
      // appBar: AppBar(
      //     backgroundColor: Colors.transparent,
      //     title: Text(widget.item['name'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((widget.item['images'] as List<dynamic>).isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 10),
                  height: 200,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
                items:
                    (widget.item['images'] as List<dynamic>).map<Widget>((img) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    child: Image.network(
                      '$uri${img['url']}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.grey[300],
                            height: 100,
                            width: double.infinity,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            // Image.network(
            //   '$uri${widget.item['images'][0]['url']}',
            //   height: 150,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  Text(
                    widget.item['name']
                        .replaceAll(RegExp(r'\s+'),
                            ' ') // Replace multiple spaces/newlines with one space
                        .trim(),
                    // maxLines: 1,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                    softWrap:
                        true, // Ensures the text wraps within the container
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(height: 10),
                  Text("Description",
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.item['description']
                            .replaceAll(RegExp(r'\s+'),
                                ' ') // Replace multiple spaces/newlines with one space
                            .trim(),
                        // maxLines: 1,
                        style: const TextStyle(),
                        textAlign: TextAlign.justify,
                        softWrap:
                            true, // Ensures the text wraps within the container
                        overflow: TextOverflow.visible,
                      )),
                  const SizedBox(height: 10),
                  Text("Select Size(select one):",
                      style: Theme.of(context).textTheme.titleMedium),
                  ...sizes.map((size) {
                    return RadioListTile<String>(
                      title: Text(
                          "${size['name']} (GHS${size['price'].toDouble()})"),
                      value: size['name'],
                      groupValue: selectedSize,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedSize = value;
                          selectedSizePrice = size['price'] is String
                              ? double.parse(size['price'])
                              : size['price'].toDouble();
                          selectedSizeId = size["_id"];
                          // print(selectedSizePrice);
                        });
                      },
                    );
                  }),
                  const Divider(),

                  // Add-ons with quantity control
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
                          "$addOnName (GHS${double.tryParse(addOnPrice)})",
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
                  const Divider(),

                  // Quantity Selector
                  Row(
                    children: [
                      const Text("Quantity:", style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Total Price Display
                  Text(
                    "Total Price: GHS${calculateTotalPrice().toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Add to Cart Button
                  // CustomButton(
                  //   title: 'Add to cart',
                  //   onTap: () => selectedSize != null
                  //       ? () {
                  //           // Here, you could add the item with selected options to the cart
                  //           addToCart();
                  //         }
                  //       : null,
                  // ),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                          ),
                        ),
                        onPressed: selectedSize != null
                            ? () {
                                // Here, you could add the item with selected options to the cart
                                addToCart();
                              }
                            : null,
                        child: isAddingToCart
                            ? const NutsActivityIndicator()
                            : const Text("Add to Cart"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Item Sizes
          ],
        ),
      ),
    );
  }
}
