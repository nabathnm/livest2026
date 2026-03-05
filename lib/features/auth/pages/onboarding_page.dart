import 'package:flutter/material.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';

class OnboardingData {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

final List<OnboardingData> onboardingPages = [
  const OnboardingData(
    imagePath:
        'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/onBoarding1.png',
    title: 'Marketplace Khusus Ternak',
    description:
        'Kami menyediakan marketplace untuk peternak yang ingin menjual ternaknya dengan mudah.',
  ),
  const OnboardingData(
    imagePath:
        'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/onBoarding2.png',
    title: 'Asisten Cerdas berbasis AI',
    description:
        'Nikmati kemudahan dalam mendapatkan informasi cepat, dengan asisten cerdas kami!',
  ),
  const OnboardingData(
    imagePath:
        'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/onBoarding3.png',
    title: 'Edukasi Ternak Interaktif',
    description:
        'Pelajari teknik beternak, kesehatan ternak, bisnis ternak dan masih banyak lagi!',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goNext() {
    if (_currentIndex < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateAway();
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _navigateAway() {
    Navigator.pushReplacementNamed(context, RouteGenerator.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == onboardingPages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Scrollable content ──
            Column(
              children: [
                // Top bar (back + skip)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back arrow
                      if (_currentIndex > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: LivestColors.textPrimary),
                          onPressed: _goBack,
                        )
                      else
                        const SizedBox(width: 48),

                      // Skip
                      if (!isLast)
                        TextButton(
                          onPressed: _navigateAway,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: LivestColors.primaryNormal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Progress dots
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: _OnboardingProgressBar(
                    total: onboardingPages.length,
                    current: _currentIndex,
                  ),
                ),

                // Page content (scrollable)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) =>
                        setState(() => _currentIndex = i),
                    itemCount: onboardingPages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingDetail(
                          data: onboardingPages[index]);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Button pinned di bawah
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: CustomButton(
          text: isLast ? 'Mulai' : 'Lanjut',
          onPressed: _goNext,
        ),
      ),
    );
  }
}

class _OnboardingProgressBar extends StatelessWidget {
  final int total;
  final int current;

  const _OnboardingProgressBar(
      {required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? LivestColors.primaryNormal
                : LivestColors.primaryLightActive,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingDetail extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingDetail({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // Gambar 360x360
          Image.network(
            data.imagePath,
            height: 360,
            width: 360,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 360,
                width: 360,
                child: Center(
                  child: CircularProgressIndicator(
                    color: LivestColors.primaryNormal,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: LivestColors.textPrimary,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: LivestColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
