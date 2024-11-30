import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../constants/global_variables.dart';

class FoodDetailsScreen extends StatelessWidget {
  final String foodName, imageUrl;

  const FoodDetailsScreen({
    super.key,
    required this.foodName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.022),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(IconlyLight.arrow_left_2, size: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.21),
                  const Center(
                    child: Text(
                      'Food Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.favorite_border_outlined),
                  const SizedBox(width: 8),
                ],
              ),
              // Container(
              //   color: AppColors.pageHeaderColor,
              //   height: size.height * 0.22,
              //   width: double.infinity,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(12, 18, 12, 0),
              //     child: Column(
              //       children: [
              //         SizedBox(height: size.height * 0.06),

              //         SizedBox(height: size.height * 0.022),
              //         // const CustomSearchBar(),
              //       ],
              //     ),
              //   ),
              // ),
              // The content section below the header
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              //     child: ListView.builder(
              //       itemCount: items.length,
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(vertical: 1.6),
              //           child: items[index],
              //         );
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
