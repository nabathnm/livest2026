class EducationModel {
  final int id;
  final DateTime createdAt;
  final String title;
  final String description;
  final String imageUrl;
  final int? categories;

  EducationModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.categories,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      categories: json['categories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'categories': categories,
    };
  }
}
