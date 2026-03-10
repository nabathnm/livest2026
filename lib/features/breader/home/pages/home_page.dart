import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/features/breader/home/pages/widgets/education_card.dart';
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
              Expanded(
                child: Consumer<EducationProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    return GridView.builder(
                      itemCount: provider.educations.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                      itemBuilder: (context, index) {
                        final education = provider.educations[index];

                        return EducationCard(
                          education: education,
                          onTap: () {
                            print(education.title);
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
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
