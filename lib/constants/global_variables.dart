import 'package:flutter/material.dart';

String uri = 'http://192.168.65.58:8000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const categoriesList = [
    'fast food & beverages',
    'pharmacy',
    'gift packages',
    'Gloceries and supermarkets',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
  ];
}

class AppColors {
  // Primary and secondary colors

  static const Color primaryColor = Color(0xFFFF6633);
  static const Color secondaryColor = Color(0xFFF0F8FF);
  static const Color tertiaryColor = Color(0xFF333333);

  // Text colors
  static const Color titleColor = Color(
      0xFF000000); // Black  static const Color bodyTextColor = Color(0xFF333333);
  static const Color buttonTextColor = Color(0xFFFFFFFF); // White
  // Button colors  static const Color buttonColor = Color(0xFF6200EE); // Matches primary color
  static const Color buttonHoverColor = Color(0xFFFF7F50);
  // Background colors  static const Color backgroundColor = Color(0xFFF5F5F5); // Light grey
  static const Color cardColor = Color(0xFFFFFFFF); // White
  // Accent colors  static const Color accentColor = Color(0xFFFFC107); // Amber
  // Additional colors
  static const Color errorColor = Color(
      0xFFB00020); // Red  static const Color dividerColor = Color(0xFFBDBDBD); // Grey
  // Colors for onPrimary and onSecondary surfaces
  static const Color onPrimaryColor = Color(0xFFFFFFFF);

  // White  static const Color onSecondaryColor = Color(0xFF000000); // Black

  static const Color pageHeaderColor = Color(0xB9B9B9B9);

  // Text colors
}
