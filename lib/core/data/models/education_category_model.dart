class EducationCategoryModel {
  final int id;
  final DateTime createdAt;
  final String name;

  EducationCategoryModel({
    required this.id, 
    required this.createdAt, 
    required this.name,
  });

  factory EducationCategoryModel.fromJson(Map<String, dynamic> json) {
    return EducationCategoryModel(
      id: json['id'], 
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 
      'created_at': createdAt.toIso8601String(),
      'name': name,
    };
  }
}
