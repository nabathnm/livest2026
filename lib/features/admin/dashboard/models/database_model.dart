class DatabaseModel {
  final int? id;
  final String title;
  final bool isDone;

  DatabaseModel({required this.id, required this.title, required this.isDone});

  // Map -> Model
  factory DatabaseModel.fromMap(Map<String, dynamic> data) {
    return DatabaseModel(
      id: data['id'] as int,
      title: data['title'] as String,
      isDone: data['is_done'] as bool,
    );
  }

  // Model -> Map
  Map<String, dynamic> toMap() {
    return {'title': title, 'is_done': isDone};
  }
}
