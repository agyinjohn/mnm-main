import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m/features/stores/screens/item_detail_screen.dart';

import '../../../constants/global_variables.dart';
import '../../home/screens/categories_page.dart';
import '../../home/widgets/custom_search_bar.dart';
import 'dummy_product_detail_screen.dart';

class DummyAvailableFoodsScreen extends StatefulWidget {
  const DummyAvailableFoodsScreen({super.key});

  @override
  State<DummyAvailableFoodsScreen> createState() =>
      _DummyAvailableFoodsScreen();
}

class _DummyAvailableFoodsScreen extends State<DummyAvailableFoodsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Available Foods',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
            child: Column(
              children: [
                _buildSearchBox(),
                const FoodCard(
                  imageUrl: 'assets/images/kfc 2.png',
                  oldAmount: 50.00,
                  newAmount: 40.00,
                  foodName: 'Classic Fried Chicken Meal Combo with Coca Cola',
                  storeName: 'KFC (Kentucky Fried Chicken)',
                ),
                const FoodCard(
                  imageUrl: 'assets/images/kfc 2.png',
                  oldAmount: 50.00,
                  newAmount: 40.00,
                  foodName: 'Classic Fried Chicken Meal Combo with Coca Cola',
                  storeName: 'KFC (Kentucky Fried Chicken)',
                ),
                const FoodCard(
                  imageUrl: 'assets/images/kfc 2.png',
                  oldAmount: 50.00,
                  newAmount: 40.00,
                  foodName: 'Classic Fried Chicken Meal Combo with Coca Cola',
                  storeName: 'KFC (Kentucky Fried Chicken)',
                ),
                const FoodCard(
                  imageUrl: 'assets/images/kfc 2.png',
                  oldAmount: 50.00,
                  newAmount: 40.00,
                  foodName: 'Classic Fried Chicken Meal Combo with Coca Cola',
                  storeName: 'KFC (Kentucky Fried Chicken)',
                ),
              ],
            )),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String foodName, storeName, imageUrl;
  final double newAmount, oldAmount;
  const FoodCard(
      {super.key,
      required this.foodName,
      required this.storeName,
      required this.imageUrl,
      required this.newAmount,
      required this.oldAmount});

  @override
  Widget build(BuildContext context) {
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
                height: size.width * 0.36,
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
                            width: size.width * 0.36,
                            height: size.width * 0.36,
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
                              SizedBox(height: size.height * 0.006),
                              Row(
                                children: [
                                  const Text(
                                    'Rating:  ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const StarRating(rating: 4.0),
                                  SizedBox(width: size.width * 0.03),
                                  const Text('4.0',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: size.height * 0.008),
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
                              SizedBox(height: size.height * 0.008),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment:
                                  // CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      '¢${oldAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    SizedBox(width: size.width * 0.012),
                                    Text(
                                      '¢${newAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: size.width * 0.042),
                                    Container(
                                      width: size.width * 0.14,
                                      height: size.height * 0.035,
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: const Center(
                                        child: Icon(
                                            Icons.shopping_basket_outlined,
                                            color: Colors.white),
                                      ),
                                    )
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
}

Widget _buildSearchBox() {
  return SizedBox(
    height: 48,
    width: double.infinity,
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Filter your search by selecting a category',
        hintStyle: const TextStyle(color: Colors.grey),
        // prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.filter_list),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        fillColor: Colors.grey.shade200,
        filled: true,
      ),
    ),
  );
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
