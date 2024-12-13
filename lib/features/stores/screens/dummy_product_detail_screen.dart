import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m/features/stores/screens/dummy_stores_screen.dart';

import '../../../constants/global_variables.dart';
import 'dummy_cart_screen.dart';

class DummyProductDetailPage extends StatefulWidget {
  const DummyProductDetailPage({super.key});

  @override
  State<DummyProductDetailPage> createState() => _DummyProductDetailPageState();
}

class _DummyProductDetailPageState extends State<DummyProductDetailPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/kfc 2.png',
    'assets/images/meat-burger.png',
  ];

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
    final theme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(IconlyLight.arrow_left_2),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'Food Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.width * 0.026,
              horizontal: size.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/kfc 2.png',
                            fit: BoxFit.cover,
                          ),
                        )),
                  ],
                ),
                SizedBox(height: size.height * 0.008),
                SizedBox(height: size.height * 0.0028),
                Text(
                  'Classic Fried Chicken Meal Combo with Coca Cola',
                  textAlign: TextAlign.center,
                  style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height * 0.024),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rating: ',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const StarRating(rating: 4.0),
                    SizedBox(width: size.width * 0.03),
                    const Text('4.0'),
                  ],
                ),
                SizedBox(height: size.height * 0.024),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.008),
                const Text(
                  'Enjoy a satisfying meal with our Classic Fried Chicken Combo, featuring two pieces of golden, crispy fried chicken, a side of fragrant jollof rice and a refreshing Coca-Cola to complete the experience.',
                  style: TextStyle(fontSize: 12),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Read more',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quantity',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    buildQuantityCount(quantity),
                  ],
                ),
                SizedBox(height: size.height * 0.06),
                _buildButton(context, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DummyCartScreen()));
                }, 'Add to cart'),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
        ));
  }

  Widget buildQuantityCount(int quantity) {
    return Row(
      children: [
        GestureDetector(
          onTap: decreaseQuantity,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Center(
              child: Text(
                '-',
                style: TextStyle(
                    fontSize: 24,
                    color: quantity == 1 ? Colors.black54 : Colors.black,
                    fontWeight:
                        quantity == 1 ? FontWeight.normal : FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: increaseQuantity,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, VoidCallback onTap, String title) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.onPrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: size.width * 0.02),
                const Icon(
                  Icons.shopping_basket_outlined,
                  color: AppColors.onPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
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
      itemSize: 20.0,
      itemBuilder: (context, _) => const Icon(
        IconlyBold.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        // print(rating);
      },
    );
  }
}
