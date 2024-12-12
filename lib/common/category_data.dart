import '../features/home/widgets/food_card.dart';

class Category {
  final String title;
  final String imagePath;
  final List subCategories;

  Category(
      {required this.title,
      required this.imagePath,
      required this.subCategories});
}

final List<Category> topCategories = [
  Category(
      title: 'Foods',
      imagePath: 'assets/images/cat-food.jpg',
      subCategories: foodList),
  Category(
      title: 'Groceries',
      imagePath: 'assets/images/cat-vegs.jpg',
      subCategories: []),
  Category(
      title: 'Drugs',
      imagePath: 'assets/images/cat-meds.jpg',
      subCategories: []),
  Category(
      title: 'Beverages',
      imagePath: 'assets/images/cat-bev.jpg',
      subCategories: []),
];

final List<Category> categories = [
  Category(
    title: 'Fast Foods & Beverages',
    imagePath: 'assets/images/cat-food.jpg',
    subCategories: foodList,
  ),
  Category(
      title: 'Drugs',
      imagePath: 'assets/images/cat-meds.jpg',
      subCategories: []),
  Category(
      title: 'Beverages',
      imagePath: 'assets/images/cat-bev.jpg',
      subCategories: []),
  Category(
      title: 'Groceries',
      imagePath: 'assets/images/cat-vegs.jpg',
      subCategories: []),
  // Category(
  //     title: 'Phones',
  //     imagePath: 'assets/images/phones.jpg',
  //     subCategories: []),
  // Category(
  //     title: 'Laptops',
  //     imagePath: 'assets/images/laptops.jpg',
  //     subCategories: []),
  // Category(
  //     title: 'Cosmetics',
  //     imagePath: 'assets/images/cosmetics.jpg',
  //     subCategories: []),
  // Category(
  //     title: 'Clothing',
  //     imagePath: 'assets/images/clothings.jpg',
  //     subCategories: []),
  // Category(
  //     title: 'Pets', imagePath: 'assets/images/pets.jpg', subCategories: []),
];

List<FoodCard> foodList = [
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(
      imageUrl: 'assets/images/fried rice 1.png', newAmount: '35.00'),
  const FoodCard(imageUrl: 'assets/images/indomie 1.png', newAmount: '70.00'),
  const FoodCard(imageUrl: 'assets/images/Shawarma 1.png', newAmount: '100.00'),
  const FoodCard(imageUrl: 'assets/images/kelewele.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
  const FoodCard(imageUrl: 'assets/images/kfc 2.png', newAmount: '50.00'),
];
