import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:m_n_m/features/stores/screens/item_detail_screen.dart';

import '../../../constants/global_variables.dart';

class AvailableStores extends StatefulWidget {
  const AvailableStores({super.key});

  @override
  State<AvailableStores> createState() => _AvailableStoresState();
}

class _AvailableStoresState extends State<AvailableStores> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Available Stores',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
            child: Column(
              children: [
                StoreCard(
                  imageUrl: 'assets/images/store1.png',
                  companyName: 'Apex Limited',
                  location: 'Adenta',
                  deliveryTime: '15',
                  rating: 4.0,
                ),
                StoreCard(
                  imageUrl: 'assets/images/store2.png',
                  companyName: 'Visca Limited',
                  location: 'Adenta',
                  deliveryTime: '13',
                  rating: 4.5,
                ),
                StoreCard(
                  imageUrl: 'assets/images/store3.png',
                  companyName: 'John Limited',
                  location: 'Cantoment',
                  deliveryTime: '12',
                  rating: 3.8,
                ),
                StoreCard(
                  imageUrl: 'assets/images/store4.png',
                  companyName: 'Adams Limited',
                  location: 'Kwadaso',
                  deliveryTime: '18',
                  rating: 4.5,
                ),
              ],
            )),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final String companyName, location, imageUrl, deliveryTime;
  final double rating;
  const StoreCard(
      {super.key,
      required this.companyName,
      required this.location,
      required this.deliveryTime,
      required this.rating,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;
// Dummy item data
    final item = {
      'name': 'Sample Item',
      'images': [
        {'url': '/sample_image1.png'},
        {'url': '/sample_image2.png'},
      ],
      'itemSizes': [
        {'name': 'S', 'price': 10.0},
        {'name': 'M', 'price': 15.0},
        {'name': 'L', 'price': 20.0},
      ],
      'attributes': {
        'Add-ons': [
          {'name': 'Extra Cheese', 'price': 2.0},
          {'name': 'Bacon', 'price': 3.0},
        ],
      },
    };

    const storeId = 'store123';

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                item: item,
                storeId: storeId,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.004),
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
                              Text(
                                companyName,
                                style: theme.bodyLarge?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: size.height * 0.006),
                              Row(
                                children: [
                                  const Icon(
                                    IconlyLight.location,
                                    size: 16,
                                  ),
                                  SizedBox(width: size.width * 0.014),
                                  Text(location),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    IconlyLight.time_circle,
                                    size: 16,
                                  ),
                                  SizedBox(width: size.width * 0.014),
                                  Text('$deliveryTime mins delivery')
                                ],
                              ),
                              SizedBox(height: size.height * 0.008),
                              Row(
                                children: [
                                  StarRating(rating: rating),
                                  SizedBox(width: size.width * 0.03),
                                  Text('$rating'),
                                ],
                              )
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
