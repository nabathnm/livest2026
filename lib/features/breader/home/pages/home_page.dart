import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/features/breader/home/provider/education_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EducationProvider>().getEducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                "https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/educationImage/event.png",
              ),
              Row(
                children: [
                  SizedBox(),
                  Column(
                    children: [
                      Text("Selamat datang, Aziz"),
                      Text("Peternakan ABC"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Consumer<EducationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        itemCount: provider.educations.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        itemBuilder: (context, index) {
                          final education = provider.educations[index];
                          return const Text("tes");
                        },
                      ),
                    ),
                  );
                },
              ),

              /// 🔹 Category Menu
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
// class _CategoryCard extends StatelessWidget {
//   final String title;

//   const _CategoryCard({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.amber.shade100,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Center(
//         child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
// }

// /// ==============================
// /// RECOMMENDATION CARD
// /// ==============================
// class _RecommendationCard extends StatelessWidget {
//   final String title;
//   final String description;

//   const _RecommendationCard({required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.network(
//             "https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/educationImage/thumbnail1.png",
//           ),
//           const SizedBox(height: 12),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 6),
//           Text(
//             description,
//             style: const TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }
