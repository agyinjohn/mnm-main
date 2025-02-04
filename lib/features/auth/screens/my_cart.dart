// Dummy cart data provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/models/cart_store_model.dart';

final cartProviderA = StateProvider<List<CartItem>>((ref) {
  return [
    CartItem(
        name: "Apex Foods & Drinks",
        location: "Amasaman",
        price: 200.00,
        quantity: 3),
    CartItem(name: "KFC", location: "Amasaman", price: 200.00, quantity: 3),
    CartItem(
        name: "Pizza man - Chicken",
        location: "Amasaman",
        price: 200.00,
        quantity: 3),
    CartItem(
        name: "Hello Restaurant",
        location: "Amasaman",
        price: 200.00,
        quantity: 3),
  ];
});

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  List<CartStore> cartStores = [];

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  Future<void> getCartItems() async {
    print('Fetching store items...');

    final storesB = await ref.read(cartProvider.notifier).fetchStores();

    List<Map<String, dynamic>> storesJson =
        storesB.map((store) => store.toJson()).toList();
    List<StoreCart> stores =
        storesJson.map((data) => StoreCart.fromJson(data)).toList();

    List<CartStore> processedStores = processStores(stores);

    // Update state to trigger UI rebuild
    setState(() {
      cartStores = processedStores;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProviderA);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: cartStores.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartStores.length,
                    itemBuilder: (context, index) {
                      final store = cartStores[index];
                      return CartItemWidget(
                        itemQuantity: store.totalItemCount,
                        itemTotalCost: store.totalCost,
                        storeLocation: store.storeLocation,
                        storeName: store.storeName,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CartItemWidget extends ConsumerWidget {
  final String storeName;
  final String storeLocation;
  final int itemQuantity;
  final double itemTotalCost;

  const CartItemWidget(
      {super.key,
      required this.itemQuantity,
      required this.itemTotalCost,
      required this.storeLocation,
      required this.storeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundCOlor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Image.asset(
            'assets/images/Vector.png',
            height: 60,
          ),
          const SizedBox(width: 10),

          // Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Location: $storeLocation"),
                  Text("Cart items: $itemQuantity"),
                ],
              ),
            ),
          ),

          // Price at the bottom
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 30), // Pushes the price down
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  "GHC ${itemTotalCost.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProviderA);
    double totalPrice = cartItems.fold(0, (sum, item) => sum + item.price);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(value: false, onChanged: (value) {}),
              const Text("Select All"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Total", style: TextStyle(fontSize: 14)),
              Text("GHC ${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {},
            child:
                const Text("Checkout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final String location;
  final double price;
  final int quantity;

  CartItem(
      {required this.name,
      required this.location,
      required this.price,
      required this.quantity});
}
