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
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      isSold: json['is_sold'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'description': description,
      'price': price,
      'is_sold': isSold,
      'type': type,
      'imageUrl': imageUrl,
      'location': location,
    };
  }
}
