import 'package:flutter/material.dart';
import 'package:m_n_m/common/widgets/bottom_bar.dart';
import 'package:m_n_m/features/address/screens/address_screen.dart';
import 'package:m_n_m/features/auth/screens/auth_screen.dart';
import 'package:m_n_m/features/auth/screens/change_password_screen.dart';
import 'package:m_n_m/features/auth/screens/forgot_password.dart';
import 'package:m_n_m/features/auth/screens/otp_screen.dart';
import 'package:m_n_m/features/auth/screens/sign_in_screen.dart';
import 'package:m_n_m/features/auth/screens/sign_up_screen.dart';
import 'package:m_n_m/features/home/screens/category_deals_screen.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:m_n_m/features/home/screens/home_screen.dart';
import 'package:m_n_m/features/order_details/screens/order_details.dart';
import 'package:m_n_m/features/product_details/screens/product_details_screen.dart';
import 'package:m_n_m/features/search/screens/search_screen.dart';
import 'package:m_n_m/models/order.dart';
import 'package:m_n_m/models/product.dart';
import 'features/admin/screens/add_product_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    case OTPScreen.routeName:
      return MaterialPageRoute(builder: (_) => const OTPScreen());
    case ChangePasswordScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
    case RivanHomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RivanHomePage(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    // case BottomBar.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const BottomBar(),
    //   );
    case SignInScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignInScreen());
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
