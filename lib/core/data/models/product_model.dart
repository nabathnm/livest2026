class ProductModel {
  final int id;
  final String userId;
  final String imageUrl;
  final String name;
  final String description;
  final int price;
  final bool isSold;
  final String type;
  final DateTime createdAt;
  final String location;
  final String phone;

  ProductModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.isSold,
    required this.type,
    required this.createdAt,
    required this.location,
    required this.phone,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      userId: json['user_id'],
      imageUrl: json['image_url'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      isSold: json['is_sold'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
      location: json['location'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'name': name,
      'description': description,
      'price': price,
      'is_sold': isSold,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'location': location,
      'phone': phone,
    };
  }
}
