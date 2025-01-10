// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:m_n_m/features/cart/cart_item_model.dart';
// import 'package:m_n_m/features/cart/providers/cart_provider.dart';
// import 'package:m_n_m/order/upload_order.dart';
// import 'package:m_n_m/payment/screens/payment_page.dart';
// import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
// import '../../../common/user_id_provider.dart';

// class CartScreen extends ConsumerStatefulWidget {
//   const CartScreen({super.key});

//   @override
//   ConsumerState<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends ConsumerState<CartScreen> {
//   final List<Map<String, dynamic>> virtualOrder = [];
//   bool isloading = false;
// @override
// void initState() {
//   super.initState();
//   getCartItems();
// }

// Future<void> getCartItems() async {
//   print('fetching store items');
//   final stores = await ref.read(cartProvider.notifier).fetchStores();
//   print(
//       'fetched stores: ${stores.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');
// }

//   Future<void> removeCartItem(String productId) async {
//     await ref.read(cartProvider.notifier).removeItem(productId);
//   }

//   void addToVirtualOrder(CartItem item, String storeId) {
//     // Find existing store in virtualOrder
//     final existingOrder = virtualOrder.firstWhere(
//       (order) => order['storeId'] == storeId,
//       orElse: () => {},
//     );

//     if (existingOrder.isNotEmpty) {
//       // Add item to the existing store order
//       setState(() {
//         existingOrder['items'].add({
//           'itemSizeId': item.productId,
//           'quantity': item.quantity,
//           'addons': item.addons.map((addon) {
//             return {
//               'name': addon.name,
//               'price': addon.price,
//             };
//           }).toList(),
//         });
//       });
//     } else {
//       // Create a new store order entry
//       setState(() {
//         virtualOrder.add({
//           'storeId': storeId,
//           'items': [
//             {
//               'itemSizeId': item.productId,
//               'quantity': item.quantity,
//               'addons': item.addons.map((addon) {
//                 return {
//                   'name': addon.name,
//                   'price': addon.price * addon.quantity,
//                 };
//               }).toList(),
//             },
//           ],
//           'address': {
//             'longitude': '-0.2235431', // Replace with actual longitude
//             'latitude': '5.5321491', // Replace with actual latitude
//           },
//         });
//       });
//     }
//   }

//   Future<void> confirmOrder() async {
//     setState(() {
//       isloading = true;
//     });
//     await uploadOrders(virtualOrder, context);
//     setState(() {
//       isloading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartState = ref.watch(cartProvider);
//     final userIdAsync = ref.watch(userIdProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Your Cart"),
//         centerTitle: true,
//       ),
//       body: userIdAsync.when(
//         data: (userId) {
//           if (userId == null) {
//             return const Center(child: Text("User not logged in"));
//           }

//           if (cartState.isEmpty) {
//             return const Center(child: Text("Your cart is empty"));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartState.length,
//                     itemBuilder: (context, storeIndex) {
//                       final store = cartState[storeIndex];
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: store.items.map((item) {
//                           return Card(
//                             margin: const EdgeInsets.symmetric(vertical: 8.0),
//                             elevation: 3,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10.0, horizontal: 16.0),
//                               title: Text(
//                                 item.name,
//                                 style: const TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "Quantity: ${item.quantity}",
//                                     style: const TextStyle(fontSize: 16),
//                                   ),
//                                   Text(
//                                     "Price: \$${item.price}",
//                                     style: const TextStyle(fontSize: 16),
//                                   ),
//                                   if (item.addons.isNotEmpty) ...[
//                                     const SizedBox(height: 8),
//                                     const Text(
//                                       "Add-ons:",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     ...item.addons.map((addon) => Padding(
//                                           padding:
//                                               const EdgeInsets.only(left: 8.0),
//                                           child: Text(
//                                             "${addon.name} - \$${addon.price} x ${addon.quantity}",
//                                             style:
//                                                 const TextStyle(fontSize: 14),
//                                           ),
//                                         )),
//                                   ],
//                                 ],
//                               ),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.add_shopping_cart,
//                                       color: Colors.blueAccent,
//                                     ),
//                                     onPressed: () =>
//                                         addToVirtualOrder(item, store.storeId),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.redAccent,
//                                     ),
//                                     onPressed: () =>
//                                         removeCartItem(item.productId),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       );
//                     },
//                   ),
//                 ),
//                 if (virtualOrder.isNotEmpty) ...[
//                   const Divider(),
//                   const Text(
//                     "Virtual Order",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   ...virtualOrder.map((order) {
//                     return ListTile(
//                       title: Text("Store ID: ${order['storeId']}"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ...order['items'].map<Widget>((item) => Text(
//                                 "Item Size ID: ${item['itemSizeId']} - Quantity: ${item['quantity']}",
//                               )),
//                           const SizedBox(height: 8),
//                           ...order['items'].map<Widget>(
//                               (it) => Text('Addons: ${it['addons']}')),
//                           const SizedBox(height: 8),
//                           Text(
//                               "Address: (${order['address']['longitude']}, ${order['address']['latitude']})"),
//                         ],
//                       ),
//                     );
//                   }),
//                   ElevatedButton(
//                     onPressed: confirmOrder,

//                     // Navigator.push(
//                     //     context,
//                     //     MaterialPageRoute(
//                     //       builder: (context) => const PaystackPaymentPage(),
//                     //     )),
//                     child: isloading
//                         ? const NutsActivityIndicator()
//                         : const Text("Confirm Order"),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, _) => const Center(child: Text("Error loading cart")),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:m_n_m/constants/utils.dart';
import 'package:m_n_m/features/stores/providers/order_details.dart';
import 'package:m_n_m/models/order_details_model.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../stores/providers/paid_order_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void initState() {
    super.initState();
    ref.read(orderProvider.notifier).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Today",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            orderState.when(
              data: (orders) {
                print(orders);

                final today = DateTime.now();
                final todayOrders = orders.where((order) {
                  final orderDate = DateTime.parse(order.date);
                  return isSameDay(orderDate, today);
                }).toList();

                final previousOrders = orders.where((order) {
                  final orderDate = DateTime.parse(order.date);
                  return !isSameDay(orderDate, today);
                }).toList();

                return SizedBox(
                  height: size.height * 0.75,
                  child: ListView(
                    children: [
                      if (todayOrders.isNotEmpty) ...[
                        const Text(
                          "Today",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...todayOrders.map((order) {
                          final DateTime dateTime = DateTime.parse(order.date);

                          return OrderCard(
                            from: order.storeName,
                            status: order.status,
                            time: timeago.format(dateTime),
                            title: order.title,
                            trackable: true,
                            id: order.id,
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                      if (previousOrders.isNotEmpty) ...[
                        const Text(
                          "Previous Orders",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...previousOrders.map((order) {
                          final DateTime dateTime = DateTime.parse(order.date);
                          return OrderCard(
                            from: order.storeName,
                            status: order.status,
                            time: timeago.format(dateTime),
                            title: order.title,
                            trackable: true,
                            id: order.id,
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to fetch orders'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(orderProvider.notifier).fetchOrders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(child: NutsActivityIndicator()),
            )
            // OrderCard(
            //   title: "Bulk order",
            //   from: "Apex Limited",
            //   time: "10:45 AM, Mon Aug 11 2024",
            //   status: "Ongoing order",
            //   trackable: true,
            // ),
            // SizedBox(height: 20),
            // Text(
            //   "Previous orders",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // OrderCard(
            //   title: "Single order",
            //   from: "Apex Limited",
            //   time: "10:45 AM, Mon Aug 11 2024",
            //   status: "Completed order",
            //   trackable: false,
            // ),
            // OrderCard(
            //   title: "Bulk order",
            //   from: "Apex Limited",
            //   time: "10:45 AM, Mon Aug 11 2024",
            //   status: "Completed order",
            //   trackable: false,
            // ),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String title;
  final String from;
  final String time;
  final String status;
  final bool trackable;
  final String id;

  const OrderCard({
    super.key,
    required this.title,
    required this.from,
    required this.time,
    required this.status,
    required this.trackable,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 50, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("From: $from"),
                  Text(time),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status,
                  style: const TextStyle(color: Colors.green),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                                orderId: id,
                              )),
                    );
                  },
                  child: const Text(
                    "View Details",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsPage extends ConsumerStatefulWidget {
  const OrderDetailsPage({super.key, required this.orderId});
  final String orderId;
  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(orderDetailsProvider.notifier).fetchOrderDetail(widget.orderId);
  }

  String? currentStatus;
  // String currentStatus = "APPROVED";
  Future<void> _refreshOrderDetails() async {
    await ref
        .read(orderDetailsProvider.notifier)
        .fetchOrderDetail(widget.orderId);
  }

  // List of statuses
  final List<String> statuses = [
    "PENDING",
    "APPROVED",
    "PICKED",
    "DELIVERED",
  ];

  // Terminal statuses
  final List<String> terminalStatuses = [
    "REJECTED",
    "CANCELLED",
  ];

  // Find the index of the current status (exclude terminal statuses)
  int get currentStep =>
      statuses.contains(currentStatus) ? statuses.indexOf(currentStatus!) : -1;

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrderDetails,
        child: orderState.when(
          data: (orderDetail) {
            if (orderDetail == null) {
              return const Center(child: Text('No order details available.'));
            }
            setState(() {
              currentStatus ??= orderDetail.status;
            });

            orderDetail.items.map((it) => print(it.addons));

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Store Information",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final phoneNumber = orderDetail
                                    .storePhone; // Replace with the contact number
                                final Uri callUri = Uri(
                                  scheme: 'tel',
                                  path: phoneNumber,
                                );
                                if (await canLaunchUrl(callUri)) {
                                  await launchUrl(callUri);
                                } else {
                                  // Handle the error (e.g., show a snackbar or alert)
                                  print("Could not launch $callUri");
                                }
                              },
                              icon: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Call",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("Store Name: ${orderDetail.storeName}"),
                        const Text("Status: Verified",
                            style: TextStyle(color: Colors.green)),
                        Text("Number: ${orderDetail.storePhone}"),
                      ],
                    ),
                  ),
                ),
                if (orderDetail.riderDetails != null) ...[
                  RiderInfoSection(
                    name: orderDetail.riderDetails!.name,
                    phone: orderDetail.riderDetails!.phone,
                  ),
                  const SizedBox(height: 16),
                  // Text(
                  //     'Rider Name: ${orderDetail.riderDetails!.name ?? "N/A"}'),
                  // Text(
                  //     'Rider Phone: ${orderDetail.riderDetails!.phone ?? "N/A"}'),
                ],
                const SizedBox(height: 16),
                const Text(
                  "Item(s) purchased",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...orderDetail.items.map((item) {
                  return PurchasedItemCard(
                    title: item.name,
                    addons: item.addons,
                    costperprice: item.itemCost,
                    sizeQuantity: {
                      item.size: "${item.quantity}",
                    },
                  );

                  // ListTile(
                  //   title: Text('${item.name} - ${item.size}'),
                  //   subtitle: Text(
                  //       'Cost: ${item.itemCost}, Quantity: ${item.quantity}'),
                  // );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery Cost:"),
                      Text("GHC ${orderDetail.deliveryCost}",
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total order cost:"),
                      Text("GHC ${orderDetail.totalCost}",
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tracking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (terminalStatuses.contains(currentStatus))
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stepper(
                                currentStep: statuses.length,
                                controlsBuilder: (context, details) =>
                                    const SizedBox(),
                                steps: statuses
                                    .map(
                                      (status) => Step(
                                        title: Text(status),
                                        content: const SizedBox.shrink(),
                                        isActive: false,
                                        state: StepState.complete,
                                      ),
                                    )
                                    .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  currentStatus == "REJECTED"
                                      ? "Your order was rejected."
                                      : "Your order was cancelled.",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Stepper(
                            currentStep: currentStep,
                            controlsBuilder: (context, details) =>
                                const SizedBox(),
                            steps: statuses
                                .map(
                                  (status) => Step(
                                    title: Text(status),
                                    content: status == 'PENDING'
                                        ? const Text(
                                            'Your order await approval from vendor')
                                        : status == 'APPROVED'
                                            ? const Text(
                                                'Your order await pickup from vendor\'s shop')
                                            : status == 'PICKED'
                                                ? const Text(
                                                    'Rider is on his way to deliver stay tuned')
                                                : const Text(
                                                    'Your order has been delivered successfully'),
                                    isActive:
                                        statuses.indexOf(status) <= currentStep,
                                    state:
                                        statuses.indexOf(status) < currentStep
                                            ? StepState.complete
                                            : StepState.indexed,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(formatDate(orderDetail.date)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: NutsActivityIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),

      // const Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [

      //       RiderInfoSection(),
      //       SizedBox(height: 20),
      // Text(
      //   "Item(s) purchased",
      //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      // ),
      // SizedBox(height: 10),
      // PurchasedItemCard(
      //   title: "2x Classic Fried Rice With Chicken",
      //   sizeQuantity: {"Medium": 1, "Large": 1},
      //   price: 90.0,
      // ),
      //       PurchasedItemCard(
      //         title: "3x Fried Noodles With Chicken & Beef",
      //         sizeQuantity: {"Medium": 1, "Large": 2},
      //         price: 175.0,
      //       ),
      //       SizedBox(height: 20),
      //       OrderTrackingSection(),
      //     ],
      //   ),
      // ),
    );
  }
}

class RiderInfoSection extends StatelessWidget {
  const RiderInfoSection({required this.name, required this.phone, super.key});
  final String? name;
  final String? phone;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Rider Information",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () async {
                    final phoneNumber =
                        phone; // Replace with the contact number
                    final Uri callUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber,
                    );
                    if (await canLaunchUrl(callUri)) {
                      await launchUrl(callUri);
                    } else {
                      // Handle the error (e.g., show a snackbar or alert)
                      print("Could not launch $callUri");
                    }
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Call",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text("Name: $name"),
            const Text("Status: Verified",
                style: TextStyle(color: Colors.green)),
            Text("Number: $phone"),
          ],
        ),
      ),
    );
  }
}

class PurchasedItemCard extends StatelessWidget {
  final String title;
  final Map<String, String> sizeQuantity;

  final double costperprice;
  final List<Addon> addons;

  const PurchasedItemCard({
    super.key,
    required this.title,
    required this.sizeQuantity,
    required this.addons,
    required this.costperprice,
  });
  double calculateTotal() {
    // Calculate item cost based on size and quantity
    double itemCost = sizeQuantity.entries.fold(0, (sum, entry) {
      int quantity = int.tryParse(entry.value) ?? 0;
      return sum + (quantity * costperprice);
    });

    // Add addon costs
    double addonsCost = addons.fold(0, (sum, addon) => sum + addon.price);

    // Total cost
    return itemCost + addonsCost;
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = calculateTotal();
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...sizeQuantity.entries.map((entry) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (entry.key == 'single') ...[
                      const Text("Quantity"),
                      Text(entry.value),
                    ] else ...[
                      Text("${entry.key}:"),
                      Text("Quantity: ${entry.value}"),
                    ]
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Price Per Item:"),
                Text("GHC ${costperprice.toStringAsFixed(2)}"),
              ],
            ),
            if (addons.isNotEmpty) ...[
              ...addons.map((addon) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${addon.name}:"),
                      Text("GHC ${addon.price.toStringAsFixed(2)}"),
                    ],
                  ))
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("SubTotal:"),
                Text("GHC ${totalCost.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTrackingSection extends StatelessWidget {
  const OrderTrackingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Tracking",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.pending, color: Colors.orange),
            SizedBox(width: 10),
            Text("Pending - Your order is on its way, please be patient"),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text("Completed - Order delivered successfully"),
          ],
        ),
      ],
    );
  }
}
