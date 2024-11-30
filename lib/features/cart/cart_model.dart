class Addon {
  final String name;
  final double price;
  final int quantity;

  Addon({
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "quantity": quantity,
      };

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json["name"],
      price: (json['price'] as num).toDouble(),
      quantity: json["quantity"] ?? 1, // Default to 1 if not specified
    );
  }
}
