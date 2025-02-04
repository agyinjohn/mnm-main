import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/cart/cart_item_model.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/order/upload_order.dart';
import 'package:m_n_m/providers/delivery_address_provider.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import '../../../common/user_id_provider.dart';

class ShopCart extends ConsumerStatefulWidget {
  final String storeId;
  final String storeName;

  const ShopCart({super.key, required this.storeId, required this.storeName});

  @override
  ConsumerState<ShopCart> createState() => _ShopCartState();
}

class _ShopCartState extends ConsumerState<ShopCart> {
  final List<Map<String, dynamic>> virtualOrder = [];
  bool isloading = false;

  Future<void> removeCartItem(String productId) async {
    await ref.read(cartProvider.notifier).removeItem(productId, widget.storeId);
  }

  void buildVirtualOrder() {
    final cartState = ref.watch(cartProvider);
    final deliveraddress = ref.watch(deliveryAddressProvider);
    virtualOrder.clear(); // Clear any previous data.

    // Filter the cart items by the selected storeId
    final store = cartState.firstWhere(
      (store) => store.storeId == widget.storeId,
      orElse: () => throw Exception('Store not found'),
    );
    print(deliveraddress!.latitude);
    final storeOrder = {
      'storeId': store.storeId,
      'items': store.items.map((item) {
        return {
          'itemSizeId': item.productId,
          'quantity': item.quantity,
          'addons': item.addons.map((addon) {
            return {
              'name': addon.name,
              'price': addon.price * addon.quantity,
            };
          }).toList(),
        };
      }).toList(),
      'address': {
        'longitude':
            '${deliveraddress.longitude}', // Replace with actual longitude
        'latitude':
            '${deliveraddress.latitude}', // Replace with actual latitude
      },
    };

    virtualOrder.add(storeOrder);
  }

  Future<void> confirmOrder() async {
    setState(() {
      isloading = true;
    });

    // Build virtual order from cart.
    buildVirtualOrder();
    print(virtualOrder);
    await uploadOrders(virtualOrder, context);

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final userIdAsync = ref.watch(userIdProvider);

    Size size = MediaQuery.of(context).size;
    // Filter the cart items by storeId
    final store = cartState.firstWhere(
      (store) => store.storeId == widget.storeId,
      orElse: () => Store(
          storeId: '',
          id: '',
          items: [],
          storeDetails: StoreDetails(name: '', location: '', isOpen: false)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your ${widget.storeName} Cart",
          overflow: TextOverflow.ellipsis,
        ),
        // centerTitle: true,
      ),
      body: userIdAsync.when(
        data: (userId) {
          if (userId == null) {
            return const Center(child: Text("User not logged in"));
          }

          if (store.items.isEmpty) {
            return const Center(
                child: Text("Your cart is empty for this store"));
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: store.items.length,
                    itemBuilder: (context, itemIndex) {
                      final item = store.items[itemIndex];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text('x${item.quantity}')
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Price: GHC ${item.price.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              if (item.addons.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Text(
                                  "Add-ons:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                ...item.addons.map((addon) => Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Text(
                                        "${addon.name} - GHC ${addon.price.toStringAsFixed(2)} x ${addon.quantity}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    )),
                              ],
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                "Total: GHC ${((item.price + item.addons.fold(0, (sum, addon) => sum + addon.price * addon.quantity)) * item.quantity).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                          trailing: Container(
                            child: Column(
                              children: [
                                // SizedBox(
                                //   child: Row(
                                //     children: [
                                //       IconButton(
                                //         onPressed: () {
                                //           if (item.quantity > 1) {
                                //             setState(() {
                                //               // item.quantity--;
                                //             });
                                //           }
                                //         },
                                //         icon: const Icon(
                                //             Icons.remove_circle_outline),
                                //         color: Colors.red,
                                //       ),
                                //       Text(
                                //         "${item.quantity}",
                                //         style: const TextStyle(
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //       IconButton(
                                //         onPressed: () {
                                //           // setState(() {
                                //           //   item.quantity++;
                                //           // });
                                //         },
                                //         icon: const Icon(
                                //             Icons.add_circle_outline),
                                //         color: Colors.green,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Deletion"),
                                          content: const Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false), // Cancel
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async =>
                                                  Navigator.of(context)
                                                      .pop(true), // Confirm
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      await removeCartItem(item.productId);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.buttonHoverColor,
                      backgroundColor: AppColors.buttonHoverColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      minimumSize: Size(size.width * 0.8, 40)),
                  onPressed: confirmOrder,
                  child: isloading
                      ? const NutsActivityIndicator()
                      : const Text(
                          "Confirm Order",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => const Center(child: Text("Error loading cart")),
      ),
    );
  }
}
