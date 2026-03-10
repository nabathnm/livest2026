class EducationModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  EducationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
