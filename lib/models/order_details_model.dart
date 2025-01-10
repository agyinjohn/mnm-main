// Model for Order Details
class OrderDetail {
  final String id;
  final String storeName;
  final String storePhone;
  final double totalCost;
  final double deliveryCost;
  final String date;
  final String status;
  final RiderDetails? riderDetails;
  final List<Item> items;

  OrderDetail({
    required this.id,
    required this.storeName,
    required this.storePhone,
    required this.date,
    required this.deliveryCost,
    required this.totalCost,
    required this.status,
    required this.riderDetails,
    required this.items,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      storeName: json['storeName'],
      storePhone: json['storePhone'],
      totalCost: json['totalCost'].toDouble(),
      deliveryCost: json['deliveryCost'].toDouble(),
      date: json['date'],
      status: json['status'],
      riderDetails: json['riderDetails'] != null
          ? RiderDetails.fromJson(json['riderDetails'])
          : null,
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
    );
  }
}

// Model for Rider Details
class RiderDetails {
  final String? name;
  final String? phone;

  RiderDetails({
    required this.name,
    required this.phone,
  });

  factory RiderDetails.fromJson(Map<String, dynamic> json) {
    return RiderDetails(
      name: json['name'],
      phone: json['phone'],
    );
  }
}

// Model for Item
class Item {
  final String name;
  final String size;
  final double itemCost;

  final int quantity;
  final List<Addon> addons;

  Item({
    required this.name,
    required this.size,
    required this.itemCost,
    required this.quantity,
    required this.addons,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      size: json['size'],
      itemCost: json['itemCost'].toDouble(),
      quantity: json['quantity'],
      addons: (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }
}

// Model for Addon
class Addon {
  final String name;
  final double price;

  Addon({required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}
