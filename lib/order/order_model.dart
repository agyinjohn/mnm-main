class Addon {
  final String name;
  final String price;

  Addon({required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}

class Item {
  final String itemSizeId;
  final String quantity;
  final List<Addon> addons;

  Item({
    required this.itemSizeId,
    required this.quantity,
    required this.addons,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemSizeId: json['itemSizeId'],
      quantity: json['quantity'],
      addons: (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemSizeId': itemSizeId,
      'quantity': quantity,
      'addons': addons.map((addon) => addon.toJson()).toList(),
    };
  }
}

class Address {
  final String longitude;
  final String latitude;

  Address({required this.longitude, required this.latitude});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

class Store {
  final String storeId;
  final List<Item> items;
  final Address address;

  Store({
    required this.storeId,
    required this.items,
    required this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['storeId'],
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'items': items.map((item) => item.toJson()).toList(),
      'address': address.toJson(),
    };
  }
}
