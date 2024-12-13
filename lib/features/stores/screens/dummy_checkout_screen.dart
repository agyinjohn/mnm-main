import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../admin/services/admin_services.dart';
import '../../search/screens/search_screen.dart';

class DummyCheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';
  final Order order;
  const DummyCheckoutScreen({
    super.key,
    required this.order,
  });

  @override
  State<DummyCheckoutScreen> createState() => _DummyCheckoutScreenState();
}

class _DummyCheckoutScreenState extends State<DummyCheckoutScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();
  final TextEditingController additionalTextController =
      TextEditingController();
  bool extraKetchup = false;
  bool extraMayonnaise = false;
  bool extraHotSauce = false;
  bool extraCutlery = false;
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Checkout',
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
              SizedBox(height: size.height * 0.015),

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

              SizedBox(height: size.height * 0.006),

              // Additional Notes

              const Row(
                children: [
                  Icon(IconlyBroken.profile),
                  SizedBox(width: 8),
                  Text(
                    'Additional Notes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.cardColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.022),
                      child: TextField(
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'I don\'t want this, this and that. But if you add this, this and that, I will do this, this and that. So just make sure you don\'t do this, this and that.',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                        controller: additionalTextController,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: extraKetchup,
                          onChanged: (bool? value) {
                            setState(() {
                              extraKetchup = value ?? false;
                            });
                          },
                        ),
                        SizedBox(width: size.width * 0.025),
                        const Text('Extra ketchup'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: extraMayonnaise,
                          onChanged: (bool? value) {
                            setState(() {
                              extraMayonnaise = value ?? false;
                            });
                          },
                        ),
                        SizedBox(width: size.width * 0.025),
                        const Text('Extra mayonnaise'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: extraHotSauce,
                          onChanged: (bool? value) {
                            setState(() {
                              extraHotSauce =
                                  value ?? false; // Toggle the checkbox
                            });
                          },
                        ),
                        SizedBox(width: size.width * 0.025),
                        const Text('Extra hot sauce'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: extraCutlery,
                          onChanged: (bool? value) {
                            setState(() {
                              extraCutlery =
                                  value ?? false; // Toggle the checkbox
                            });
                          },
                        ),
                        SizedBox(width: size.width * 0.025),
                        const Text('Add extra cutlery'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.012),

              CustomButton(title: 'Confirm', onTap: () {}),
              SizedBox(height: size.height * 0.012),
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
