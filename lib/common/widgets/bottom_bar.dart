// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:m_n_m/features/account/screens/account_screen.dart';
// import 'package:m_n_m/features/cart/screens/cart_screen.dart';
// import 'package:m_n_m/features/home/screens/home_page.dart';

// import '../../features/cart/providers/cart_provider.dart';

// class BottomBar extends ConsumerStatefulWidget {
//   static const String routeName = '/actual-home';
//   const BottomBar({super.key});

//   @override
//   ConsumerState<BottomBar> createState() => _BottomBarState();
// }

// class _BottomBarState extends ConsumerState<BottomBar> {
//   int _page = 0;
//   double bottomBarWidth = 42;
//   double bottomBarBorderWidth = 5;

//   List<Widget> pages = [
//     const HomeScreen(),
//     const AccountScreen(),
//     const CartScreen(),
//   ];
// // 
//   void updatePage(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cart = ref.watch(cartProvider);

//     return Scaffold(
//       body: pages[_page],
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: _page,
//       //   selectedItemColor: GlobalVariables.selectedNavBarColor,
//       //   unselectedItemColor: GlobalVariables.unselectedNavBarColor,
//       //   backgroundColor: GlobalVariables.backgroundColor,
//       //   iconSize: 28,
//       //   onTap: updatePage,
//       //   items: [
//       //     // HOME
//       //     BottomNavigationBarItem(
//       //       icon: Container(
//       //         width: bottomBarWidth,
//       //         decoration: BoxDecoration(
//       //           border: Border(
//       //             top: BorderSide(
//       //               color: _page == 0
//       //                   ? GlobalVariables.selectedNavBarColor
//       //                   : GlobalVariables.backgroundColor,
//       //               width: bottomBarBorderWidth,
//       //             ),
//       //           ),
//       //         ),
//       //         child: const Icon(
//       //           Icons.home_outlined,
//       //         ),
//       //       ),
//       //       label: '',
//       //     ),
//       //     // ACCOUNT
//       //     BottomNavigationBarItem(
//       //       icon: Container(
//       //         width: bottomBarWidth,
//       //         decoration: BoxDecoration(
//       //           border: Border(
//       //             top: BorderSide(
//       //               color: _page == 1
//       //                   ? GlobalVariables.selectedNavBarColor
//       //                   : GlobalVariables.backgroundColor,
//       //               width: bottomBarBorderWidth,
//       //             ),
//       //           ),
//       //         ),
//       //         child: const Icon(
//       //           Icons.person_outline_outlined,
//       //         ),
//       //       ),
//       //       label: '',
//       //     ),
//       //     // CART
//       //     BottomNavigationBarItem(
//       //       icon: Container(
//       //         width: bottomBarWidth,
//       //         decoration: BoxDecoration(
//       //           border: Border(
//       //             top: BorderSide(
//       //               color: _page == 2
//       //                   ? GlobalVariables.selectedNavBarColor
//       //                   : GlobalVariables.backgroundColor,
//       //               width: bottomBarBorderWidth,
//       //             ),
//       //           ),
//       //         ),
//       //         child: b.Badge(
//       //           badgeStyle: const b.BadgeStyle(
//       //             elevation: 0,
//       //             badgeColor: Colors.white,
//       //           ),
//       //           badgeContent: Text(userCartLen.toString()),
//       //           child: const Icon(
//       //             Icons.shopping_cart_outlined,
//       //           ),
//       //         ),
//       //       ),
//       //       label: '',
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }
