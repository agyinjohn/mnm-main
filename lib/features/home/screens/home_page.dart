import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_n_m/common/widgets/loading_schema.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/auth/screens/my_cart.dart';
import 'package:m_n_m/features/cart/providers/cart_provider.dart';
import 'package:m_n_m/features/home/screens/categories_page.dart';
import 'package:m_n_m/features/home/screens/category_deals_screen.dart';
import 'package:m_n_m/features/home/screens/change_delivery_address.dart';
import 'package:m_n_m/features/home/screens/error_page.dart';
import 'package:m_n_m/features/home/screens/notification_page.dart';
import 'package:m_n_m/features/home/screens/profile_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:m_n_m/features/stores/screens/store_items_screen.dart';
import 'package:m_n_m/features/stores/screens/stores_list_page.dart';
import 'package:m_n_m/providers/notification_provider.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/delivery_address_model.dart';
import '../../../providers/delivery_address_provider.dart';
import '../../../providers/popular_stores_provider.dart';
import '../../cart/screens/cart_screen.dart';
import '../../stores/widgets/custom_drawer.dart';
import '../../cart/providers/cart_provider.dart' as ct;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/homescreen';
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? _currentAddress;
  Position? _currentPosition;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> getCartItems() async {
    print('Fetching store items');

    // Check if the ref is still mounted before proceeding
    if (!mounted) {
      print('Aborted fetch because ref is disposed.');
      return;
    }

    try {
      ref.read(ct.cartProvider.notifier).fetchStores();

      // Double-check if the widget is still mounted before printing or updating UI state
      // if (ref.mounted) {
      //   print('Fetched stores: ${stores.map((e) => e.items.map((i) => i.addons.map((a) => a.name)))}');
      // }
    } catch (e) {
      print('Error fetching store items: $e');
    }
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

      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   _currentPosition!.latitude,
      //   _currentPosition!.longitude,
      // );
      final tempAddress = DeliveryAddress(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        streetName: "Current Location",
        subLocality: "Unknown",
      );
      await ref
          .read(popularStoresProvider.notifier)
          .fetchPopularStores(tempAddress);

      await ref
          .read(deliveryAddressProvider.notifier)
          .setDeliveryAddress(
              context: context,
              latitude: _currentPosition!.latitude,
              longitude: _currentPosition!.longitude)
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException("Network request timed out");
      });
      print(mounted);
      if (mounted) {
        await getCartItems();
      }
    } on TimeoutException catch (error) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ErrorPage()));
    } catch (e) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ErrorPage()));
    } finally {
      setState(() {
        isloading = false;
      });
      // isloading = false;
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
    final List<Widget> bottomNavigationBarScreens = [
      HomePage(
        scaffoldKey: scaffoldKey,
        currentAddress: _currentAddress,
        onCategoryTap: () => _onItemTapped(1), // Navigate to Categories
        onFavouriteTap: () => _onItemTapped(2), // Navigate to Favourites
      ),
      const CategoriesPage(),
      const OrderListPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      body: isloading
          ? const Center(child: HomeLoadingShimmer())
          : Padding(
              padding: const EdgeInsets.only(top: 20),
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
                  icon: Icon(Icons.shopping_cart),
                  label: 'Orders',
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

class HomePage extends ConsumerStatefulWidget {
  final VoidCallback onCategoryTap;
  final VoidCallback onFavouriteTap;
  final String? currentAddress;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage(
      {super.key,
      required this.onCategoryTap,
      required this.onFavouriteTap,
      required this.currentAddress,
      required this.scaffoldKey,
      required});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
          'Discover the most popular categories \nand find what you need in just a few taps. \nFrom delicious meals to daily essentials, we\'ve got \nyou covered.',
    },
    {
      'overlayColor': Colors.grey[900]!.withOpacity(0.88),
      'title': 'Exclusive Offers Just For You',
      'content':
          'Save big with our exclusive offers! \nCheck out the latest deals and discounts available \nonly for a limited time. \nDon\'t miss out!',
    },
    {
      'overlayColor': Colors.red.withOpacity(0.88),
      'title': 'Safe and Fast Delivery',
      'content':
          'Enjoy safe and fast delivery right to your \n doorstep. \nOur delivery partners follow strict safety protocols \nto ensure your order arrives \nsafely and quickly.',
    },
  ];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deliveryAddress = ref.watch(deliveryAddressProvider);

    // Listen to changes in deliveryAddress and fetch popular stores

    final popularStores = ref.watch(popularStoresProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          HomeHeader(
            scaffoldKey: widget.scaffoldKey,
          ),

          // const SearchBar(),
          const SizedBox(height: 16),
          CarouselSlider(
            items: [
              Center(
                child: Image.asset(
                  'assets/images/f1.png',
                  fit: BoxFit.cover,
                  width:
                      double.infinity, // Make it expand to the available width
                  height: double.infinity, // Stretch to the container's height
                ),
              ),
              Image.asset(
                'assets/images/s1.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Image.asset(
                'assets/images/t1.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ],
            options: CarouselOptions(
              height: 140, // Increased height
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              viewportFraction: 1, // Reduce to make the center image larger
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Top Categories',
            icon: const Icon(Icons.category),
            onViewAllTap: widget.onCategoryTap,
            showViewall: true,
          ),
          const SizedBox(height: 12),
          CategoryList(categories: categories),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          SectionHeader(
            title: 'Popular Shops',
            icon: const Icon(Icons.star_outline_outlined),
            onViewAllTap: widget.onFavouriteTap,
          ),
          const SizedBox(height: 12),
          // FavouriteList(favourites: favourites),
          popularStores.when(
            data: (stores) {
              print(stores.length);
              if (stores.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                        height: 150,
                        image: AssetImage('assets/images/outbound.png')),
                    Center(
                      child: Text(
                        "You location seems a bit far",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                );
              }

              return SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Horizontal scrolling
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index]['stores'][0];

                    print(store);
                    // print(store['stores']['storeName']);
                    final totalRatedValue = store['ratings'] != null &&
                            store['ratings']['totalRatedValue'] != null
                        ? double.tryParse(store['ratings']['totalRatedValue']
                                .toString()) ??
                            0.0
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FavouriteCard(
                          reviews: store['ratings']['totalPeopleRated'],
                          isOpened: store['open'],
                          storeId: store['_id'],
                          location: store['storeAddress'],
                          title: store['storeName'],
                          vendor: 'Apex',
                          price: 30,
                          rating: totalRatedValue,
                          image: '${store['images']['imageId']['url']}'),
                    );
                  },
                ),
              );
            },
            loading: () => SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Simulating 5 loading items
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 170, // Adjust width to match store cards
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            error: (err, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Failed to fetch popular stores',
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (deliveryAddress != null) {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref
                                      .read(popularStoresProvider.notifier)
                                      .fetchPopularStores(deliveryAddress);
                                } catch (e) {
                                  debugPrint('Hey');
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: isLoading
                                ? const NutsActivityIndicator()
                                : const Text(
                                    'Refresh',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ))
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Other widgets (HomeHeader, SearchBar, BannerCard, etc.) remain unchanged...

// Home header widget
class HomeHeader extends ConsumerWidget {
  const HomeHeader({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(totalCartItemsProvider);
    final notificationUnreadCount = ref.watch(unreadNotificationCountProvider);
    // print(cartCount);
    final deliveryAddress = ref.watch(deliveryAddressProvider);
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              print('taopppp');
              scaffoldKey.currentState?.openDrawer();
            },
            child: const CircleIconButton(
              icon: Padding(
                padding: EdgeInsets.all(12.0),
                child: Image(
                    fit: BoxFit.contain,
                    height: 10,
                    width: 20,
                    image: AssetImage(
                      'assets/images/apps.png',
                    )),
              ),
            )),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeliveryAddressPage())),
            child: LocationInfo(
              location: deliveryAddress != null
                  ? "${deliveryAddress.streetName}, ${deliveryAddress.subLocality}"
                  : "No delivery address set",
              currentLocation: deliveryAddress != null
                  ? 'Delivery Address'
                  : 'Set Delivery Address',
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationsPage())),
          child: IconWithBadge(
              icon: Icons.notifications_none_outlined,
              badgeCount: notificationUnreadCount),
        ),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CartPage())),
          child: IconWithBadge(
              icon: Icons.shopping_cart_outlined, badgeCount: cartCount),
        ),
      ],
    );
  }
}

// Circle icon button widget
class CircleIconButton extends StatelessWidget {
  final Widget icon;

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
      child: icon,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 4),
                Center(
                  child: Text(
                    currentLocation,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Text(
            location,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
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
        Icon(
          icon,
          size: 28,
          color: Colors.black,
        ),
        if (badgeCount >= 1)
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
          clipBehavior: Clip.none,
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
            Positioned(
              top: 10, // Move image upwards outside the container
              right: -3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/s.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Image.asset(
                        'assets/images/neak.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/wa.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/v.png',
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Image.asset(
                          'assets/images/lotion.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
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
  final bool showViewall;
  const SectionHeader(
      {super.key,
      required this.title,
      required this.onViewAllTap,
      this.showViewall = false,
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
        if (showViewall)
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
      children: widget.categories.asMap().entries.map((entry) {
        int index = entry.key; // Get the index
        var category = entry.value;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreListScreen(
                      categoryName: GlobalVariables.categoriesList[index])),
            );
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
            reviews: 1,
            isOpened: true,
            storeId: ' 2',
            title: favourites[index].title,
            vendor: favourites[index].vendor,
            price: favourites[index].price,
            rating: favourites[index].rating,
            image: favourites[index].image,
            location: 'Location',
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
  final String location;
  final String storeId;
  final bool isOpened;
  final int reviews;
  const FavouriteCard({
    super.key,
    required this.title,
    required this.vendor,
    required this.price,
    required this.rating,
    required this.image,
    required this.location,
    required this.storeId,
    required this.isOpened,
    required this.reviews,
  });
//1. Amidu
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
            child: CachedNetworkImage(
              imageUrl: widget.image,
              height: 184,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: SizedBox(),
              ),
              errorWidget: (context, url, error) => Container(
                height: 184,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    size: 50, color: Colors.grey),
              ),
            ),
          ),
          //  Image.network(
          //   widget.image,
          //   height: 184,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),

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
            top: 4,
            right: 8,
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoreItemsScreen(
                          ratings: widget.rating,
                          reviews: widget.reviews,
                          isOpened: widget.isOpened,
                          location: widget.location,
                          storeId: widget.storeId,
                          storeName: widget.title,
                          banner: widget.image))),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black,
                ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.location,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   '\$${widget.price.toStringAsFixed(2)}',
                //   style: const TextStyle(
                //       fontSize: 22,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white),
                // ),
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
