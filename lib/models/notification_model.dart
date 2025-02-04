class NotificationModel {
  final String id;
  final String type;
  final Map<String, dynamic> details;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      type: json['type'],
      details: json['details'],
      isRead: json['isRead'] ?? false, // Ensure a default value
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }

  // Add the copyWith method
  NotificationModel copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? details,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isRead: isRead ?? this.isRead,
    );
  }
}
