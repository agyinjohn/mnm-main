import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m/common/widgets/custom_button_2.dart';
// import 'package:m_n_m/features/stores/screens/item_detail_screen.dart';

import '../../../constants/global_variables.dart';
// import '../../home/screens/categories_page.dart';
// import '../../home/widgets/custom_search_bar.dart';
import '../../home/screens/home_page.dart';
import 'dummy_product_detail_screen.dart';

class DummyCartScreen extends StatefulWidget {
  const DummyCartScreen({super.key});

  @override
  State<DummyCartScreen> createState() => _DummyCartScreen();
}

class _DummyCartScreen extends State<DummyCartScreen> {
  int quantity = 1;

  increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  decreaseQuantity() {
    setState(() {
      if (quantity == 1) return;
      quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your Cart',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CartCard(
                      imageUrl: 'assets/images/kfc 2.png',
                      newAmount: 40.00,
                      foodName:
                          'Classic Fried Chicken Meal Combo with Coca Cola',
                      storeName: 'KFC (Kentucky Fried Chicken)',
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              onTap: () {},
              title: 'Check out',
            ),
          ],
        ),
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  final String foodName, storeName, imageUrl;
  final double newAmount;
  const CartCard({
    super.key,
    required this.foodName,
    required this.storeName,
    required this.imageUrl,
    required this.newAmount,
  });

  @override
  Widget build(BuildContext context) {
    // int quantity = 1;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DummyProductDetailPage()));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.004),
              child: Container(
                height: size.width * 0.30,
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
                            imageUrl,
                            // 'assets/images/kfc 2.png',
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // const SizedBox(width: 0.238),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.5,
                                child: Text(
                                  foodName,
                                  style: theme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: size.height * 0.004),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.business,
                                    size: 16,
                                  ),
                                  SizedBox(width: size.width * 0.014),
                                  Text(
                                    storeName,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.004),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '¢${newAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: size.width * 0.044),
                                    _buildQuantityCount(),
                                  ]),
                            ],
                          ),
                        )
                        //
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityCount() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: const Center(
              child: Text(
                '-',
                style: TextStyle(
                    fontSize: 22,
                    // color: quantity == 1 ? Colors.black54 : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[100],
          ),
          child: const Center(
            child: Text(
              '1',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  const StarRating({required this.rating});
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 14.0,
      itemBuilder: (context, _) => const Icon(
        IconlyBold.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {},
    );
  }
}
