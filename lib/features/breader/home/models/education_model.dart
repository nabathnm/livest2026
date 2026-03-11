class EducationModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String shortDesc;
  final List<ArtikelSection> sections;

  const EducationModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.shortDesc,
    required this.sections,
  });
}

class ArtikelSection {
  final String type;
  final String? heading;
  final String? paragraph;
  final List<String>? chips;
  final List<String>? checklist;

  const ArtikelSection({
    required this.type,
    this.heading,
    this.paragraph,
    this.chips,
    this.checklist,
  });
}
