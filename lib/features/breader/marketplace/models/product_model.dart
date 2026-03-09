class ProductModel {
  final int id;
  final String userId;
  final String? name;
  final String? description;
  final int? price;
  final bool? isSold;
  final String? type;
  final String? imageUrl;
  final String? location;
  final String? phone;
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    this.name,
    this.description,
    this.price,
    this.isSold,
    this.type,
    this.imageUrl,
    this.location,
    this.phone,
    this.createdAt,
  });

  ProductModel copyWith({
    int? id,
    String? userId,
    String? name,
    String? description,
    int? price,
    bool? isSold,
    String? type,
    String? imageUrl,
    String? location,
    String? phone,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      isSold: isSold ?? this.isSold,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      isSold: json['is_sold'],
      type: json['type'],
      imageUrl: json['image_url'],
      location: json['location'],
      phone: json['phone'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'user_id': userId,
      'name': name,
      'description': description,
      'price': price,
      'is_sold': isSold,
      'type': type,
      'image_url': imageUrl,
      'location': location,
      'phone': phone,
    };

    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }

    return data;
  }
}
