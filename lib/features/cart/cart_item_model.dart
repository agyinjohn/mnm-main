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

class Addon {
  final String name;
  final double price;
  final int quantity;
  final String id;

  Addon({
    required this.name,
    required this.price,
    required this.quantity,
    required this.id,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      '_id': id,
    };
  }
}

class CartItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String id;
  final List<Addon> addons;

  CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.id,
    required this.addons,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      id: json['_id'] as String,
      addons: (json['addons'] as List<dynamic>?)
              ?.map((addon) => Addon.fromJson(addon as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      '_id': id,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}

class Store {
  final String storeId;
  final String id;
  final List<CartItem> items;
  final StoreDetails storeDetails;
  Store({
    required this.storeId,
    required this.id,
    required this.items,
    required this.storeDetails,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['storeId'] as String,
      id: json['_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      storeDetails:
          StoreDetails.fromJson(json['storeDetails'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'storeDetails': storeDetails.toJson(),
    };
  }
}
