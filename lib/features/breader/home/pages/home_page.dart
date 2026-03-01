import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              /// 🔹 Welcome Section
              const Text(
                "Welcome, Nabath 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Mau belajar apa hari ini?",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// 🔹 Category Menu
              Row(
                children: const [
                  Expanded(child: _CategoryCard(title: "Kesehatan")),
                  SizedBox(width: 12),
                  Expanded(child: _CategoryCard(title: "Pakan")),
                  SizedBox(width: 12),
                  Expanded(child: _CategoryCard(title: "Perawatan")),
                ],
              ),

              const SizedBox(height: 40),

              /// 🔹 Recommendation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Khusus untukmu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "See more",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Recommendation Cards
              Row(
                children: const [
                  Expanded(
                    child: _RecommendationCard(
                      title: "Judul 1",
                      description: "Deskripsi singkat edukasi 1",
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _RecommendationCard(
                      title: "Judul 2",
                      description: "Deskripsi singkat edukasi 2",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==============================
/// CATEGORY CARD
/// ==============================
class _CategoryCard extends StatelessWidget {
  final String title;

  const _CategoryCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

/// ==============================
/// RECOMMENDATION CARD
/// ==============================
class _RecommendationCard extends StatelessWidget {
  final String title;
  final String description;

  const _RecommendationCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
