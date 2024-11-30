import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/common/widgets/loading_schema.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/features/home/screens/categories_page.dart';
import 'package:m_n_m/features/home/screens/category_deals_screen.dart';
import 'package:m_n_m/features/home/screens/error_page.dart';
import 'package:m_n_m/features/home/screens/favourite_screen.dart';
import 'package:m_n_m/features/home/screens/profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../cart/screens/cart_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/homescreen';
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method to get current location
  // Method to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      isloading = true;
    });
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle permission denied

      setState(() {
        isloading = false;
      });
      return;
    }

    // Specify the settings for location retrieval
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best, // Desired accuracy level
      distanceFilter:
          100, // Minimum distance (in meters) before an update is triggered
    );

    // Get the current position using the settings
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    print(position);
    setState(() {
      _currentPosition = position;
      isloading = false;
    });

    // Perform reverse geocoding to get the address
    _getAddressFromLatLng();
  }

  // Method to get address (city and specific location) from coordinates
  Future<void> _getAddressFromLatLng() async {
    try {
      setState(() {
        isloading = true;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        // Get the specific address or city
        _currentAddress = "${place.street}, ${place.locality}";
        isloading = false;
      });
      print("Found this code ");
    } catch (e) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ErrorPage()));
    } finally {
      isloading = false;
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final List<Widget> bottomNavigationBarScreens = [
      HomePage(
        currentAddress: _currentAddress,
        onCategoryTap: () => _onItemTapped(1), // Navigate to Categories
        onFavouriteTap: () => _onItemTapped(2), // Navigate to Favourites
      ),
      const CategoriesPage(),
      const FavouritesPage(),
      const CartScreen(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: isloading
          ? const Center(child: HomeLoadingShimmer())
          : SafeArea(
              child: bottomNavigationBarScreens[_selectedIndex],
            ),
      bottomNavigationBar: isloading
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.grey[100],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              unselectedLabelStyle: const TextStyle(color: Colors.black54),
              selectedLabelStyle: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category_outlined),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onCategoryTap;
  final VoidCallback onFavouriteTap;
  final String? currentAddress;
  HomePage(
      {super.key,
      required this.onCategoryTap,
      required this.onFavouriteTap,
      required this.currentAddress,
      required});

  final List<Category> categories = [
    Category('Food', 'assets/images/cat-food.jpg'),
    Category('Groceries', 'assets/images/cat-vegs.jpg'),
    Category('Drugs', 'assets/images/cat-meds.jpg'),
    Category('Beverages', 'assets/images/cat-bev.jpg'),
  ];

  final List<Favourite> favourites = [
    Favourite(
      title: 'Meat Burger (Beef)',
      vendor: 'KFC - KNUST',
      price: 50.00,
      rating: 4.5,
      image: 'assets/images/meat-burger.jpg',
    ),
    Favourite(
      title: 'Meat Pizza (Gizzard)',
      vendor: 'Pizza Man',
      price: 45.00,
      rating: 4.5,
      image: 'assets/images/pizza.jpg',
    ),
  ];

  final List<Map<String, dynamic>> homeBannerItems = [
    {
      'overlayColor': Colors.green.withOpacity(0.88),
      'title': 'Explore Popular Categories',
      'content':
          'Discover the most popular categories \nand find what you need in just a few taps. \nFrom delicious meals to daily essentials, we\'ve got you covered.',
    },
    {
      'overlayColor': Colors.grey[900]!.withOpacity(0.88),
      'title': 'Exclusive Offers Just For You',
      'content':
          'Save big with our exclusive offers! \nCheck out the latest deals and discounts available only for a limited time. \nDon\'t miss out!',
    },
    {
      'overlayColor': Colors.red.withOpacity(0.88),
      'title': 'Safe and Fast Delivery',
      'content':
          'Enjoy safe and fast delivery right to your doorstep. \nOur delivery partners follow strict safety protocols to ensure your order arrives safely and quickly.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(
            currentLocation: currentAddress,
          ),
          const SizedBox(height: 16),
          const SearchBar(),
          const SizedBox(height: 16),
          CarouselSlider.builder(
            itemCount: homeBannerItems.length,
            itemBuilder: (context, index, realIndex) {
              final item = homeBannerItems[index];
              return BannerCard(item: item);
            },
            options: CarouselOptions(
              height: 165,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              viewportFraction: 1,
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Categories',
            icon: const Icon(Icons.category_outlined),
            onViewAllTap: onCategoryTap,
          ),
          const SizedBox(height: 12),
          CategoryList(categories: categories),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Favourites',
            icon: const Icon(Icons.star_outline_outlined),
            onViewAllTap: onFavouriteTap,
          ),
          const SizedBox(height: 12),
          FavouriteList(favourites: favourites),
        ],
      ),
    );
  }
}

// Other widgets (HomeHeader, SearchBar, BannerCard, etc.) remain unchanged...

// Home header widget
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key, required this.currentLocation});
  final String? currentLocation;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Row(
      children: [
        const CircleIconButton(icon: Icons.category_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: LocationInfo(
            location: currentLocation!,
            currentLocation: 'Current Location',
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          },
          child: IconWithBadge(
              icon: Icons.shopping_cart_outlined, badgeCount: cart.length),
        ),
        const SizedBox(width: 8),
        const IconWithBadge(
            icon: Icons.notifications_none_outlined, badgeCount: 1),
      ],
    );
  }
}

// Circle icon button widget
class CircleIconButton extends StatelessWidget {
  final IconData icon;

  const CircleIconButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(icon),
    );
  }
}

// Location info widget
class LocationInfo extends StatelessWidget {
  final String location;
  final String currentLocation;

  const LocationInfo(
      {super.key, required this.location, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 4),
                Text(
                  currentLocation,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        Text(
          location,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Icon with badge widget
class IconWithBadge extends StatelessWidget {
  final IconData icon;
  final int badgeCount;

  const IconWithBadge(
      {super.key, required this.icon, required this.badgeCount});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(icon, size: 28),
        Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 7,
            child: Text(
              badgeCount.toString(),
              style: const TextStyle(fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }
}

// Search bar widget
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.filter_list),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          fillColor: Colors.grey.shade200,
          filled: true,
        ),
      ),
    );
  }
}

// Banner card widget
class BannerCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const BannerCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 165,
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/card-pattern.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Container(
              width: double.infinity,
              height: 165,
              decoration: BoxDecoration(
                color: item['overlayColor'],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 26, 70, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['content'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final Icon icon;
  final VoidCallback onViewAllTap;

  const SectionHeader(
      {super.key,
      required this.title,
      required this.onViewAllTap,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onViewAllTap,
          child: const Row(
            children: [
              Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 12,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Category list widget
class CategoryList extends StatefulWidget {
  final List<Category> categories;

  const CategoryList({super.key, required this.categories});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.categories.map((category) {
        return GestureDetector(
          onTap: () {
            navigateToCategoryPage(context, category.title);
          },
          child: CategoryCard(
            title: category.title,
            imagePath: category.imagePath,
          ),
        );
      }).toList(),
    );
  }
}

// Favourite list widget
class FavouriteList extends StatelessWidget {
  final List<Favourite> favourites;

  const FavouriteList({super.key, required this.favourites});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favourites.length,
        itemBuilder: (context, index) {
          return FavouriteCard(
            title: favourites[index].title,
            vendor: favourites[index].vendor,
            price: favourites[index].price,
            rating: favourites[index].rating,
            image: favourites[index].image,
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const CategoryCard({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 86,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(imagePath)),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class FavouriteCard extends StatefulWidget {
  final String title;
  final String vendor;
  final double price;
  final double rating;
  final String image;

  const FavouriteCard({
    super.key,
    required this.title,
    required this.vendor,
    required this.price,
    required this.rating,
    required this.image,
  });

  @override
  _FavouriteCardState createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.image,
              height: 184,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColor.withOpacity(0.1),
                  AppColors.primaryColor.withOpacity(0.35),
                  AppColors.primaryColor.withOpacity(0.6),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star,
                      color: AppColors.primaryColor, size: 12),
                  const SizedBox(width: 3),
                  Text(
                    widget.rating.toString(),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vendor: ${widget.vendor}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${widget.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Category {
  final String title;
  final String imagePath;

  Category(this.title, this.imagePath);
}

class Favourite {
  final String title;
  final String vendor;
  final double price;
  final double rating;
  final String image;

  Favourite({
    required this.title,
    required this.vendor,
    required this.price,
    required this.rating,
    required this.image,
  });
}
