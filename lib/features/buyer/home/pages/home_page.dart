import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/buyer/home/pages/detail_product_page.dart';
import 'package:livest/features/buyer/home/pages/search_page.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_chip.dart';
import 'package:livest/features/buyer/home/pages/widgets/category_item.dart';
import 'package:livest/features/buyer/home/pages/widgets/product_card.dart';
import 'package:livest/features/buyer/home/provider/buyer_marketplace_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<BuyerMarketplaceProvider>().getProducts(),
    );
  }

  void _openSearch({String? initialQuery}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
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
                    GestureDetector(
                      onTap: _openSearch,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            width: 2,
                            color: LivestColors.primaryLight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              'Cari ternak yang ingin kamu beli!',
                              style: LivestTypography.bodyMd.copyWith(
                                color: LivestColors.textSecondary,
                              ),
                            ),
                            Image.asset("assets/images/icon/search.png"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _chips.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          title: e,
                          onTap: () => _openSearch(initialQuery: e),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: .start,
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const SizedBox(height: 16),
                    Text('Untukmu', style: LivestTypography.bodyLgBold),
                    const SizedBox(height: 8),

                    Consumer<BuyerMarketplaceProvider>(
                      builder: (context, provider, _) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: LivestColors.primaryNormal,
                            ),
                          );
                        }
                        if (provider.products.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                'Produk tidak tersedia',
                                style: LivestTypography.bodyMd.copyWith(
                                  color: LivestColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.products.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 314,
                              ),
                          itemBuilder: (context, index) {
                            final product = provider.products[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailProductPage(product: product),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
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
