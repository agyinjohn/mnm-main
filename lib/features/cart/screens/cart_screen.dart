import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/features/cart/cart_item_model.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/order/upload_order.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import '../../../common/user_id_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final List<Map<String, dynamic>> virtualOrder = [];
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  Future<void> getCartItems() async {
    print('fetching store items');
    final stores = await ref.read(cartProvider.notifier).fetchStores();
    print(
        'fetched stores: ${stores.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');
  }

  Future<void> removeCartItem(String productId) async {
    await ref.read(cartProvider.notifier).removeItem(productId);
  }

  void addToVirtualOrder(CartItem item, String storeId) {
    // Find existing store in virtualOrder
    final existingOrder = virtualOrder.firstWhere(
      (order) => order['storeId'] == storeId,
      orElse: () => {},
    );

    if (existingOrder.isNotEmpty) {
      // Add item to the existing store order
      setState(() {
        existingOrder['items'].add({
          'itemSizeId': item.productId,
          'quantity': item.quantity,
          'addons': item.addons.map((addon) {
            return {
              'name': addon.name,
              'price': addon.price,
            };
          }).toList(),
        });
      });
    } else {
      // Create a new store order entry
      setState(() {
        virtualOrder.add({
          'storeId': storeId,
          'items': [
            {
              'itemSizeId': item.productId,
              'quantity': item.quantity,
              'addons': item.addons.map((addon) {
                return {
                  'name': addon.name,
                  'price': addon.price * addon.quantity,
                };
              }).toList(),
            },
          ],
          'address': {
            'longitude': '-0.2235431', // Replace with actual longitude
            'latitude': '5.5321491', // Replace with actual latitude
          },
        });
      });
    }
  }

  Future<void> confirmOrder() async {
    setState(() {
      isloading = true;
    });
    await uploadOrders(virtualOrder);
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final userIdAsync = ref.watch(userIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
      ),
      body: userIdAsync.when(
        data: (userId) {
          if (userId == null) {
            return const Center(child: Text("User not logged in"));
          }

          if (cartState.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.length,
                    itemBuilder: (context, storeIndex) {
                      final store = cartState[storeIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: store.items.map((item) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Quantity: ${item.quantity}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Price: \$${item.price}",
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "${addon.name} - \$${addon.price} x ${addon.quantity}",
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        )),
                                  ],
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () =>
                                        addToVirtualOrder(item, store.storeId),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () =>
                                        removeCartItem(item.productId),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                if (virtualOrder.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    "Virtual Order",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...virtualOrder.map((order) {
                    return ListTile(
                      title: Text("Store ID: ${order['storeId']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order['items'].map<Widget>((item) => Text(
                                "Item Size ID: ${item['itemSizeId']} - Quantity: ${item['quantity']}",
                              )),
                          const SizedBox(height: 8),
                          ...order['items'].map<Widget>(
                              (it) => Text('Addons: ${it['addons']}')),
                          const SizedBox(height: 8),
                          Text(
                              "Address: (${order['address']['longitude']}, ${order['address']['latitude']})"),
                        ],
                      ),
                    );
                  }),
                  ElevatedButton(
                    onPressed: confirmOrder,
                    child: isloading
                        ? const NutsActivityIndicator()
                        : const Text("Confirm Order"),
                  ),
                ],
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
