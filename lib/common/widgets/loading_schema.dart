import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Location Placeholder
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerBox(width: 180, height: 30),
                  Row(
                    children: [
                      _buildShimmerCircle(size: 25),
                      const SizedBox(width: 16),
                      _buildShimmerCircle(size: 25),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar Placeholder
              _buildShimmerBox(width: double.infinity, height: 40),
              const SizedBox(height: 16),

              // Explore Popular Categories Placeholder
              _buildShimmerBox(width: double.infinity, height: 100),
              const SizedBox(height: 16),
              _buildShimmerBox(width: double.infinity, height: 100),
              const SizedBox(height: 16),

              // Categories Title and View All Placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerBox(width: 100, height: 20),
                  _buildShimmerBox(width: 60, height: 20),
                ],
              ),
              const SizedBox(height: 10),

              // Categories Icons Placeholder
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        _buildShimmerCircle(size: 50),
                        const SizedBox(height: 8),
                        _buildShimmerBox(width: 40, height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Favourites Title and View All Placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerBox(width: 100, height: 20),
                  _buildShimmerBox(width: 60, height: 20),
                ],
              ),
              const SizedBox(height: 10),

              // Favourite Items Placeholder
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildShimmerBox(width: 120, height: 150),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for rectangular shimmer placeholders
  Widget _buildShimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
      ),
    );
  }

  // Helper function for circular shimmer placeholders (icons, etc.)
  Widget _buildShimmerCircle({required double size}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
