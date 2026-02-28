import 'package:flutter/material.dart';
import '../models/education_model.dart';

class EducationDetailPage extends StatelessWidget {
  final EducationModel education;

  const EducationDetailPage({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Edukasi")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              education.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(education.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
