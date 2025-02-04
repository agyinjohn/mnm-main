// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class CartStore {
//   final String storeId;
//   final double totalCost;
//   final int totalItemCount;

//   CartStore({
//     required this.storeId,
//     required this.totalCost,
//     required this.totalItemCount,
//   });
// }

// List<CartStore> processStores(List<dynamic> stores) {
//   final DecodedStore = jsonDecode(stores.toString());
//   print(jsonEncode(stores));
//   return DecodedStore.map((store) {
//     double totalCost = 0.0;
//     int totalItemCount = 0;

//     for (var item in store['items']) {
//       int itemQuantity = item['quantity'];
//       double itemPrice = item['price'];

//       // Add item cost
//       totalCost += itemQuantity * itemPrice;
//       totalItemCount += itemQuantity;

//       // Process addons
//       for (var addon in item['addons']) {
//         int addonQuantity = addon['quantity'];
//         double addonPrice = addon['price'];
//         totalCost += addonQuantity * addonPrice;
//       }
//     }

//     return CartStore(
//       storeId: store['storeId'],
//       totalCost: totalCost,
//       totalItemCount: totalItemCount,
//     );
//   }).toList();
// }

// void main() {
//   // Sample JSON response (simulating the data returned from your cart provider)
//   String jsonResponse = '''
//   [
//     {
//       "storeId": "678b75a1cef76ece594e2a35",
//       "_id": "679ff35913b7570abae15aa5",
//       "items": [
//         {
//           "productId": "6798380ed57257892b1168ea",
//           "name": "Apex cuisine royale",
//           "quantity": 1,
//           "price": 1.0,
//           "_id": "679ff41213b7570abae15aba",
//           "addons": []
//         },
//         {
//           "productId": "6798380ed57257892b1168ea",
//           "name": "Apex cuisine royale",
//           "quantity": 1,
//           "price": 1.0,
//           "_id": "67a0e45d13b7570abae15cc5",
//           "addons": []
//         },
//         {
//           "productId": "6798380ed57257892b1168ea",
//           "name": "Apex cuisine royale",
//           "quantity": 1,
//           "price": 1.0,
//           "_id": "67a0e7c313b7570abae15d26",
//           "addons": [
//             {"name": "rubber", "price": 1.0, "quantity": 1, "_id": "67a0e7c313b7570abae15d27"},
//             {"name": "Ahaban", "price": 0.0, "quantity": 1, "_id": "67a0e7c313b7570abae15d28"},
//             {"name": "gari", "price": 0.8, "quantity": 1, "_id": "67a0e7c313b7570abae15d29"}
//           ]
//         }
//       ]
//     }
//   ]
//   ''';

//   // Decode JSON response into a list of Store objects
//   List<dynamic> decodedJson = jsonDecode(jsonResponse);
//   List<Store> stores = decodedJson.map((data) => Store.fromJson(data)).toList();

//   // Process stores to get total items and total cost
//   List<CartStore> cartStores = processStores(stores);

//   // Print results
//   for (var cartStore in cartStores) {
//     print('Store ID: ${cartStore.storeId}');
//     print('Total Items: ${cartStore.totalItemCount}');
//     print('Total Cost: \$${cartStore.totalCost.toStringAsFixed(2)}');
//     print('-------------------------');
//   }
// }

// Model for Store
class StoreCart {
  final String storeId;
  final String id;
  final List<Item> items;
  final StoreDetails storeDetails;
  StoreCart(
      {required this.storeId,
      required this.id,
      required this.items,
      required this.storeDetails});

  // Convert JSON data into Store object
  factory StoreCart.fromJson(Map<String, dynamic> json) {
    return StoreCart(
      storeId: json['storeId'],
      storeDetails:
          StoreDetails.fromJson(json['storeDetails'] as Map<String, dynamic>),
      id: json['_id'],
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
    );
  }

  // Convert Store object into JSON
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
      "storeDetails": StoreDetails
    };
  }
}

class StoreDetails {
  final String name;
  final String location;
  final bool isOpen;
  StoreDetails({
    required this.name,
    required this.location,
    required this.isOpen,
  });

  factory StoreDetails.fromJson(Map<String, dynamic> json) {
    return StoreDetails(
      name: json['name'] as String,
      location: json['location'] as String,
      isOpen: json['isOpen'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'isOpen': isOpen,
    };
  }
}

class Item {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final List<Addon> addons;

  Item(
      {required this.productId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.addons});

  // Convert JSON data into Item object
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json['productId'],
      name: json['name'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      addons: (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }

  // Convert Item object into JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}

// Model for Addon
class Addon {
  final String name;
  final double price;
  final int quantity;

  Addon({required this.name, required this.price, required this.quantity});

  // Convert JSON data into Addon object
  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }

  // Convert Addon object into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}

// Model for processed cart store
class CartStore {
  final String storeId;
  final String storeName;
  final String storeLocation;
  final double totalCost;
  final int totalItemCount;
  final bool isOpen;
  CartStore(
      {required this.storeId,
      required this.totalCost,
      required this.storeLocation,
      required this.storeName,
      required this.isOpen,
      required this.totalItemCount});
}

// Function to process stores and calculate total cost & item count
List<CartStore> processStores(List<StoreCart> stores) {
  print(stores[0]);
  return stores.map((store) {
    double totalCost = 0.0;
    int totalItemCount = 0;

    for (var item in store.items) {
      totalItemCount += item.quantity;

      // Calculate the total price of addons for this item
      double addonCost = item.addons
          .fold(0.0, (sum, addon) => sum + (addon.quantity * addon.price));

      // Total cost for this item, including addons
      totalCost += item.quantity * (item.price + addonCost);
    }

    return CartStore(
        storeId: store.storeId,
        totalCost: totalCost,
        totalItemCount: totalItemCount,
        storeLocation: store.storeDetails.location,
        isOpen: store.storeDetails.isOpen,
        storeName: store.storeDetails.name);
  }).toList();
}
