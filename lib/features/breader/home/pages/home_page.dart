// lib/features/buyer/home/pages/home_page.dart
// MODIFIED: Section "Untukmu" (marketplace) diganti dengan section "Edukasi Ternak"

import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/breader/home/models/education_data.dart';
import 'package:livest/features/breader/home/pages/education_detail_page.dart';
import 'package:livest/features/breader/home/pages/education_page.dart';
import 'package:livest/features/buyer/home/pages/search_page.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_chip.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_item.dart';
import 'package:livest/features/breader/home/models/education_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _categories = [
    {
      'icon': 'assets/images/icon/sapi.png',
      'title': 'Sapi',
      'price': '15,7 jt',
    },
    {
      'icon': 'assets/images/icon/kambing.png',
      'title': 'Kambing',
      'price': '3,4 jt',
    },
    {'icon': 'assets/images/icon/ayam.png', 'title': 'Ayam', 'price': '340 K'},
    {
      'icon': 'assets/images/icon/bebek.png',
      'title': 'Bebek',
      'price': '569 K',
    },
  ];

  static const _chips = ['Sapi Madura', 'Ayam Negeri', 'Bebek', 'Ayam'];

  // Edukasi category icons
  static const _edukasiCategories = [
    {'icon': Icons.favorite_outline_rounded, 'title': 'Kesehatan'},
    {'icon': Icons.cleaning_services_outlined, 'title': 'Perawatan'},
    {'icon': Icons.grass_outlined, 'title': 'Pakan'},
  ];

  void _openSearch({String? initialQuery}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  void _openEdukasi({String? initialCategory}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EducationPage()),
    );
  }

  void _openArtikel(EducationModel artikel) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EducationDetailPage(artikel: artikel)),
    );
  }

  // Preview artikel untuk ditampilkan di home (ambil 5 pertama)
  List<EducationModel> get _previewArtikel => dummyArtikel.take(5).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/onboarding/avatar.png',
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang, Aziz',
                              style: LivestTypography.bodyMdBold,
                            ),
                            Text(
                              'Peternakan ABC, Jawa Timur',
                              style: LivestTypography.bodySm.copyWith(
                                color: LivestColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Banner ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/banner.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Harga Pasar Ternak',
                      style: LivestTypography.bodyLgBold,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Harga Pasar ──
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _categories.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: CategoryItem(
                          iconPath: item['icon']!,
                          title: item['title']!,
                          price: item['price']!,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Edukasi Ternak Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Edukasi Ternak', style: LivestTypography.bodyLgBold),
                    GestureDetector(
                      onTap: _openEdukasi,
                      child: Row(
                        children: [
                          Text(
                            'Lihat semua',
                            style: LivestTypography.bodySm.copyWith(
                              color: LivestColors.primaryNormal,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: LivestColors.primaryNormal,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Edukasi Category Icons ──
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: _edukasiCategories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GestureDetector(
                        onTap: _openEdukasi,
                        child: Column(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: LivestColors.baseWhite,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                cat['icon'] as IconData,
                                color: LivestColors.primaryNormal,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat['title'] as String,
                              style: LivestTypography.bodySm.copyWith(
                                color: LivestColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Artikel Preview (grid) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Disusun khusus untukmu!',
                      style: LivestTypography.bodyLgBold,
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _previewArtikel.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 280,
                          ),
                      itemBuilder: (context, index) {
                        final artikel = _previewArtikel[index];
                        return EducationCard(
                          artikel: artikel,
                          onTap: () => _openArtikel(artikel),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Artikel Card (Home Preview) ──────────────────────────────────────────────

class EducationCard extends StatelessWidget {
  final EducationModel artikel;
  final VoidCallback onTap;

  const EducationCard({required this.artikel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: LivestColors.baseWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              artikel.imageUrl,
              height: 128,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(height: 128, color: const Color(0xFFE8EDF0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artikel.category),
                  const SizedBox(height: 8),
                  Text(
                    artikel.title,
                    style: LivestTypography.bodyMdSemiBold,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artikel.shortDesc,
                    style: LivestTypography.caption.copyWith(
                      color: LivestColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
