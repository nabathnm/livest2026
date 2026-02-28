class EducationCategoryModel {
  final int id;
  final String name;

  EducationCategoryModel({required this.id, required this.name});

  factory EducationCategoryModel.fromJson(Map<String, dynamic> json) {
    return EducationCategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
