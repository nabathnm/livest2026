import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/breader/home/models/education_data.dart';
import 'package:livest/features/breader/home/pages/education_detail_page.dart';
import 'package:livest/features/breader/home/pages/education_page.dart';
import 'package:livest/features/buyer/home/pages/search_page.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_chip.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_item.dart';
import 'package:livest/features/breader/home/models/education_model.dart';
import 'package:provider/provider.dart';

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
      'iconharga': "assets/images/icon/harganaik.png",
      'bgColor': LivestColors.greenLightHover,
      'txColor': LivestColors.greenDarkHover,
    },
    {
      'icon': 'assets/images/icon/kambing.png',
      'title': 'Kambing',
      'price': '3,4 jt',
      'iconharga': "assets/images/icon/hargaturun.png",
      'bgColor': LivestColors.redLightHover,
      'txColor': LivestColors.redDarkHover,
    },
    {
      'icon': 'assets/images/icon/ayam.png',
      'title': 'Ayam',
      'price': '340 K',
      'iconharga': "assets/images/icon/harganaik.png",
      'bgColor': LivestColors.greenLightHover,
      'txColor': LivestColors.greenDarkHover,
    },
    {
      'icon': 'assets/images/icon/bebek.png',
      'title': 'Bebek',
      'price': '569 K',
      'iconharga': "assets/images/icon/hargaturun.png",
      'bgColor': LivestColors.redLightHover,
      'txColor': LivestColors.redDarkHover,
    },
  ];

  static const _chips = ['Sapi Madura', 'Ayam Negeri', 'Bebek', 'Ayam'];

  // Edukasi category icons
  static const _edukasiCategories = [
    {'image': 'assets/images/onboarding/kesehatan.png', 'title': 'Kesehatan'},
    {'image': 'assets/images/onboarding/perawatan.png', 'title': 'Perawatan'},
    {'image': 'assets/images/onboarding/pakan.png', 'title': 'Pakan'},
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
              Consumer<ProfileProvider>(
                builder: (context, profile, _) {
                  final name = profile.fullName ?? 'Peternak';
                  final farm = profile.farmName ?? '';
                  final location = profile.farmLocation ?? '';
                  final subtitle = [
                    farm,
                    location,
                  ].where((s) => s.isNotEmpty && s != '-').join(', ');
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat datang, $name',
                          style: LivestTypography.bodyMdBold,
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: LivestTypography.bodySm.copyWith(
                              color: LivestColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  );
                },
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
                          iconPath: item['icon'] as String,
                          title: item['title'] as String,
                          price: item['price'] as String,
                          icon: item['iconharga'] as String,
                          bgColor: item['bgColor'] as Color,
                          txColor: item['txColor'] as Color,
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
                    GestureDetector(
                      onTap: _openEdukasi,
                      child: Text(
                        'Edukasi Ternak',
                        style: LivestTypography.bodyLgBold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Edukasi Category Icons ──
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _edukasiCategories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => _openEdukasi(
                            initialCategory: cat['title'] as String,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 116,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: LivestColors.baseWhite,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    cat['image'] as String,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: LivestColors.primaryLightHover,
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Text(
                      artikel.category,
                      style: LivestTypography.caption.copyWith(
                        color: LivestColors.primaryNormal,
                      ),
                    ),
                  ),
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
