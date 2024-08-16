// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:mnm/app_colors.dart';
// import 'package:mnm/widgets/home_banner.dart';

// class HomeScreen extends StatelessWidget {
//   final List<Category> categories = [
//     Category('Food', 'assets/images/logo.jpg'),
//     Category('Groceries', 'assets/images/logo.jpg'),
//     Category('Drugs', 'assets/images/logo.jpg'),
//     Category('Beverages', 'assets/images/logo.jpg'),
//   ];

//   final List<Favourite> favourites = [
//     Favourite(
//       title: 'Meat Burger (Beef)',
//       vendor: 'KFC - KNUST',
//       price: 50.00,
//       rating: 4.5,
//       image: 'assets/images/logo.jpg',
//     ),
//     Favourite(
//       title: 'Meat Pizza (Gizzard)',
//       vendor: 'Pizza Man',
//       price: 45.00,
//       rating: 4.5,
//       image: 'assets/images/logo.jpg',
//     ),
//   ];

//   final List<dynamic> homeBannerItems = [
//     {
//       'title': 'Explore Popular Categories',
//       'content':
//           'Discover the most popular categories and find what you need in just a few taps. \nFrom delicious meals to daily essentials, we\'ve got you covered.',
//     },
//     {
//       'title': 'Exclusive Offers Just For You',
//       'content':
//           'Save big with our exclusive offers! \nCheck out the latest deals and discounts available only for a limited time. \nDon\'t miss out!',
//     },
//     {
//       'title': 'Safe and Fast Delivery',
//       'content':
//           'Enjoy safe and fast delivery right to your doorstep. Our delivery parteners follow strict safety protocols to ensure your order arrives safely adn quickly.',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16.0, 18, 16, 0),
//           child: Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       width: 45,
//                       height: 45,
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.grey.shade300),
//                       child: const Icon(Icons.category_outlined),
//                     ),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 155,
//                             height: 30,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: const Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.location_on_outlined),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     'Current Location',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const Text(
//                             'Ayeduase Gate, Kumasi',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Stack(
//                       children: [
//                         Icon(
//                           Icons.shopping_cart_outlined,
//                           size: 28,
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: CircleAvatar(
//                             backgroundColor: AppColors.primaryColor,
//                             radius: 7,
//                             child: Text(
//                               '1',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 6),
//                     const Stack(
//                       children: [
//                         Icon(
//                           Icons.notifications_none_outlined,
//                           size: 28,
//                         ),
//                         Positioned(
//                           right: 0,
//                           top: 0,
//                           child: CircleAvatar(
//                             backgroundColor: AppColors.primaryColor,
//                             radius: 7,
//                             child: Text(
//                               '1',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 // Search Bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search',
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: const Icon(Icons.filter_list),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(28),
//                         borderSide: BorderSide.none,
//                       ),
//                       fillColor: Colors.grey.shade200,
//                       filled: true,
//                     ),
//                   ),
//                 ),

//                 // Explore Categories Banner

//                 // Padding(
//                 //     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 //     child: HomeBanner(
//                 //         title: homeBannerItems[0]['title'],
//                 //         content: homeBannerItems[0]['content'],
//                 //         overlayColor: Colors.green)),

//                 // Categories Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.category_outlined),
//                       const Text(
//                         'Categories',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: const Row(
//                             children: [
//                               Text(
//                                 'View all',
//                                 style: TextStyle(
//                                     color: AppColors.primaryColor,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Icon(Icons.arrow_forward_ios_outlined,
//                                   size: 12, color: AppColors.primaryColor),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 GridView.builder(
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: categories.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 4,
//                     childAspectRatio: 3 / 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemBuilder: (context, index) {
//                     return CategoryCard(
//                       title: categories[index].title,
//                       imagePath: categories[index].imagePath,
//                     );
//                   },
//                 ),

//                 // Favourites Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.favorite_border_outlined),
//                       const Text(
//                         'Favourites',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {},
//                           child: const Row(
//                             children: [
//                               Text(
//                                 'View all',
//                                 style: TextStyle(
//                                     color: AppColors.primaryColor,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Icon(Icons.arrow_forward_ios_outlined,
//                                   size: 12, color: AppColors.primaryColor),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 200,
//                   width: 300,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: favourites.length,
//                     itemBuilder: (context, index) {
//                       return FavouriteCard(
//                         title: favourites[index].title,
//                         vendor: favourites[index].vendor,
//                         price: favourites[index].price,
//                         rating: favourites[index].rating,
//                         image: favourites[index].image,
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.grey[300],
//         currentIndex: 0,
//         selectedItemColor: AppColors.primaryColor,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category_outlined),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CategoryCard extends StatelessWidget {
//   final String title;
//   final String imagePath;

//   const CategoryCard({required this.title, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 68,
//           height: 74,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//             ),
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//         ),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }

// class FavouriteCard extends StatelessWidget {
//   final String title;
//   final String vendor;
//   final double price;
//   final double rating;
//   final String image;

//   const FavouriteCard({
//     required this.title,
//     required this.vendor,
//     required this.price,
//     required this.rating,
//     required this.image,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160,
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(8)),
//                 child: Image.asset(
//                   image,
//                   height: 100,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.orange, size: 12),
//                       Text(
//                         rating.toString(),
//                         style: const TextStyle(fontSize: 10),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Vendor: $vendor',
//                   style: const TextStyle(fontSize: 10, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '₵ ${price.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Category {
//   final String title;
//   final String imagePath;

//   Category(this.title, this.imagePath);
// }

// class Favourite {
//   final String title;
//   final String vendor;
//   final double price;
//   final double rating;
//   final String image;

//   Favourite({
//     required this.title,
//     required this.vendor,
//     required this.price,
//     required this.rating,
//     required this.image,
//   });
// }
