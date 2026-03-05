import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:livest/data/models/education_model.dart';
import 'package:livest/features/breader/home/pages/education_detail_page.dart';
import 'package:livest/features/breader/home/providers/education_provider.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EducationProvider>().fetchEducations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edukasi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(fontSize: 16),
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
            const SizedBox(height: 12),
            Row(
              children: const [
                EducationCategoryBadge(label: "makan"),
                SizedBox(width: 12),
                EducationCategoryBadge(label: "makan"),
                SizedBox(width: 12),
                EducationCategoryBadge(label: "makan"),
                SizedBox(width: 12),
                EducationCategoryBadge(label: "makan"),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Rekomendasi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<EducationProvider>(
                builder: (context, educationProvider, child) {
                  if (educationProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (educationProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        educationProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (educationProvider.educations.isEmpty) {
                    return const Center(
                      child: Text("Belum ada konten edukasi."),
                    );
                  }

                  return ListView.builder(
                    itemCount: educationProvider.educations.length,
                    itemBuilder: (context, index) {
                      final education = educationProvider.educations[index];
                      return EducationCard(education: education);
                    },
                  );
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
