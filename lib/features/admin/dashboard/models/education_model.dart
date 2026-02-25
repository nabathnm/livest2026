class EducationModel {
  final int id;
  final String title;
  final String description;

  EducationModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'desc': description};
  }
}
