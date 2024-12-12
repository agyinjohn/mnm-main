import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../admin/services/admin_services.dart';
import '../../search/screens/search_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  // !!! ONLY FOR ADMIN!!!
  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      onSuccess: () {
        setState(() {
          currentStep += 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: AppBar(
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: GlobalVariables.appBarGradient,
      //       ),
      //     ),
      //     title: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Expanded(
      //           child: Container(
      //             height: 42,
      //             margin: const EdgeInsets.only(left: 15),
      //             child: Material(
      //               borderRadius: BorderRadius.circular(7),
      //               elevation: 1,
      //               child: TextFormField(
      //                 onFieldSubmitted: navigateToSearchScreen,
      //                 decoration: InputDecoration(
      //                   prefixIcon: InkWell(
      //                     onTap: () {},
      //                     child: const Padding(
      //                       padding: EdgeInsets.only(
      //                         left: 6,
      //                       ),
      //                       child: Icon(
      //                         Icons.search,
      //                         color: Colors.black,
      //                         size: 23,
      //                       ),
      //                     ),
      //                   ),
      //                   filled: true,
      //                   fillColor: Colors.white,
      //                   contentPadding: const EdgeInsets.only(top: 10),
      //                   border: const OutlineInputBorder(
      //                     borderRadius: BorderRadius.all(
      //                       Radius.circular(7),
      //                     ),
      //                     borderSide: BorderSide.none,
      //                   ),
      //                   enabledBorder: const OutlineInputBorder(
      //                     borderRadius: BorderRadius.all(
      //                       Radius.circular(7),
      //                     ),
      //                     borderSide: BorderSide(
      //                       color: Colors.black38,
      //                       width: 1,
      //                     ),
      //                   ),
      //                   hintText: 'Search Amazon.in',
      //                   hintStyle: const TextStyle(
      //                     fontWeight: FontWeight.w500,
      //                     fontSize: 17,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         Container(
      //           color: Colors.transparent,
      //           height: 42,
      //           margin: const EdgeInsets.symmetric(horizontal: 10),
      //           child: const Icon(Icons.mic, color: Colors.black, size: 25),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Details',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rider Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name:'),
                      Text('Status:'),
                      Text('Number:'),
                    ],
                  ),
                  SizedBox(width: size.width * 0.05),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Agyin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Verified',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '0242458248',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: size.height * 0.042,
                      width: size.width * 0.18,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColors.primaryColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.008),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconlyBroken.calling,
                              size: size.width * 0.05,
                              color: AppColors.onPrimaryColor,
                            ),
                            SizedBox(width: size.width * 0.01),
                            Text('Call',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onPrimaryColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),

              // SizedBox(height: size.height * 0.036),
              // const Row(children: [
              //   Icon(IconlyLight.arrow_left_2),
              //   Text(
              //     'Order Details',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //   ),
              // ]),
              // SizedBox(height: size.height * 0.026),
              // const Text(
              //   'View order details',
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.black12,
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Order Date:      ${DateFormat().format(
              //         DateTime.fromMillisecondsSinceEpoch(
              //             widget.order.orderedAt),
              //       )}'),
              //       Text('Order ID:          ${widget.order.id}'),
              //       Text('Order Total:      \$${widget.order.totalPrice}'),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 10),

              const Text(
                'Item(s) Purchased',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Dummy data

              const ItemPurchased(
                orderId: '12345',
                description: '2x Classic Fried Rice With Chicken',
              ),

              const ItemPurchased(
                orderId: '67890',
                description: '2x Fried Noodles With Chicken & Beef',
              ),

              // After the items

              Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery fee:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              // fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Total',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'GHC 15.00',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'GHC 175.00',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.black12,
              //     ),
              //   ),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       for (int i = 0; i < widget.order.products.length; i++)
              //         Row(
              //           children: [
              //             Image.network(
              //               widget.order.products[i].images[0],
              //               height: 120,
              //               width: 120,
              //             ),
              //             const SizedBox(width: 5),
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     widget.order.products[i].name,
              //                     style: const TextStyle(
              //                       fontSize: 17,
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //                     maxLines: 2,
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                   Text(
              //                     'Qty: ${widget.order.quantity[i]}',
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //     ],
              //   ),
              // ),
              SizedBox(height: size.height * 0.006),
              const Text(
                'Order Tracking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.006),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Stepper(
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    // if (user.type == 'admin') {
                    //   return CustomButton(
                    //     text: 'Done',
                    //     onTap: () => changeOrderStatus(details.currentStep),
                    //   );
                    // }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                      title: const Text('Pending'),
                      content: const Text(
                        'Your order is yet to be delivered',
                      ),
                      isActive: currentStep > 0,
                      state: currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Completed'),
                      content: const Text(
                        'Your order has been delivered, you are yet to sign.',
                      ),
                      isActive: currentStep > 1,
                      state: currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Received'),
                      content: const Text(
                        'Your order has been delivered and signed by you.',
                      ),
                      isActive: currentStep > 2,
                      state: currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Delivered'),
                      content: const Text(
                        'Your order has been delivered and signed by you!',
                      ),
                      isActive: currentStep >= 3,
                      state: currentStep >= 3
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeFormatter {
  static String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a, EEE MMM d, yyyy').format(now);
  }
}

class ItemPurchased extends StatelessWidget {
  final String orderId, description;

  const ItemPurchased({
    super.key,
    required this.description,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.014),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.cardColor,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/kfc 2.png',
                    width: size.width * 0.26,
                    height: size.width * 0.26,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.018),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Order #12345',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.004),
                        Text(
                          '2x Classic Fried Rice With Chicken',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.004),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                DateTimeFormatter.getCurrentDateTime(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text('Quantity: ',
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            Text('2',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor)),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Size:',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.006),
                                  Text(
                                    'Medium',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Large',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Quantity',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.006),
                                  Text(
                                    '1',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '1',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Center(
                                    child: Text(
                                      'Price',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.006),
                                  Text(
                                    'GHC 70.00',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'GHC 90.00',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: size.height * 0.026),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Total',
                        //       style: theme.textTheme.bodyMedium?.copyWith(
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     Text(
                        //       'GHC 160.00',
                        //       style: theme.textTheme.bodyMedium?.copyWith(
                        //         fontWeight: FontWeight.bold,
                        //         color: AppColors.primaryColor,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
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
