class Order {
  final String title;
  final String storeName;
  final String date;
  final String status;
  final String id;

  Order({
    required this.title,
    required this.storeName,
    required this.date,
    required this.status,
    required this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        title: json['title'],
        storeName: json['storeName'],
        date: json['date'],
        status: json['status'],
        id: json['id']);
  }
}
