import 'package:flutter/material.dart';
import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:livest/features/breader/home/pages/education_detail_page.dart';
import 'package:livest/features/breader/home/services/education_service.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final educationService = EducationService();
  List<EducationModel> educations = [];

  Future<void> fetchData() async {
    final data = await educationService.fetchData();
    setState(() {
      educations = data;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edukasi"), leading: Icon(Icons.back_hand)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            TextField(
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Masukkan pencarian...",
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Row(
              spacing: 12,
              children: [
                EducationCategoryBadge(label: "makan"),
                EducationCategoryBadge(label: "makan"),
                EducationCategoryBadge(label: "makan"),
                EducationCategoryBadge(label: "makan"),
              ],
            ),
            Text("Rekomendasi"),
            Expanded(
              child: ListView.builder(
                itemCount: educations.length,
                itemBuilder: (context, index) {
                  final currentEducations = educations[index];
                  return EducationCard(education: currentEducations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationCard extends StatelessWidget {
  final EducationModel education;

  const EducationCard({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EducationDetailPage(education: education),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                education.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
              Text(
                education.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(education.description),
            ],
          ),
        ),
      ),
    );
  }
}

class EducationCategoryBadge extends StatelessWidget {
  final String label;

  const EducationCategoryBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
