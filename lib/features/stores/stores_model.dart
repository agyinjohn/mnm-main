class CategoryResponse {
  final String id;
  final Category category;
  final List<Store> stores;

  CategoryResponse({
    required this.id,
    required this.category,
    required this.stores,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['_id'] as String,
      category: Category.fromJson(json['category']),
      stores: (json['stores'] as List)
          .map((store) => Store.fromJson(store))
          .toList(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final bool enable;
  final List<String> subCategories;

  Category({
    required this.id,
    required this.name,
    required this.enable,
    required this.subCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      name: json['name'] as String,
      enable: json['enable'] as bool,
      subCategories: List<String>.from(json['subCategories']),
    );
  }
}

class Store {
  final String id;
  final String storeName;
  final double distance;
  final List<Item> items;

  Store({
    required this.id,
    required this.storeName,
    required this.distance,
    required this.items,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'] as String,
      storeName: json['storeName'] as String,
      distance: (json['distance'] as num).toDouble(),
      items:
          (json['items'] as List).map((item) => Item.fromJson(item)).toList(),
    );
  }
}

class Item {
  final String id;
  final String name;
  final String description;
  final List<ItemSize> itemSizes;
  final Map<String, dynamic> attributes;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.itemSizes,
    required this.attributes,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      itemSizes: (json['itemSizes'] as List)
          .map((size) => ItemSize.fromJson(size))
          .toList(),
      attributes: json['attributes'] as Map<String, dynamic>,
    );
  }
}

class ItemSize {
  final String id;
  final String itemId;
  final String name;
  final int price;
  final bool enable;

  ItemSize({
    required this.id,
    required this.itemId,
    required this.name,
    required this.price,
    required this.enable,
  });

  factory ItemSize.fromJson(Map<String, dynamic> json) {
    return ItemSize(
      id: json['_id'] as String,
      itemId: json['itemId'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      enable: json['enable'] as bool,
    );
  }
}
