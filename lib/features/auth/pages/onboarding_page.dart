import 'package:flutter/material.dart';
import 'package:livest/core/routes/route_generator.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
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
    imagePath: 'assets/images/onboarding/onBoarding1.png',
    title: 'Marketplace Khusus Ternak',
    description:
        'Kami menyediakan marketplace untuk peternak yang ingin menjual ternaknya dengan mudah.',
  ),
  const OnboardingData(
    imagePath: 'assets/images/onboarding/onBoarding2.png',
    title: 'Asisten Cerdas berbasis AI',
    description:
        'Nikmati kemudahan dalam mendapatkan informasi cepat, dengan asisten cerdas kami!',
  ),
  const OnboardingData(
    imagePath: 'assets/images/onboarding/onBoarding3.png',
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
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back arrow
                      if (_currentIndex > 0)
                        GestureDetector(
                          onTap: _goBack,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1EBE6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 16,
                              color: Color.fromARGB(255, 43, 32, 22),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),

                      // Skip
                      if (!isLast)
                        TextButton(
                          onPressed: _navigateAway,
                          child: Text(
                            'Skip',
                            style: LivestTypography.buttonMd.copyWith(
                              color: LivestColors.primaryNormal,
                              decoration: TextDecoration.underline,
                              decorationColor: LivestColors.primaryNormal,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Progress dots (centered without full-width padding to float correctly)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Center(
                    child: _OnboardingProgressBar(
                      total: onboardingPages.length,
                      current: _currentIndex,
                    ),
                  ),
                ),

                // Page content (scrollable)
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentIndex = i),
                    itemCount: onboardingPages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingDetail(data: onboardingPages[index]);
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

  const _OnboardingProgressBar({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: index == total - 1 ? 0 : 8),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: isActive
                ? LivestColors.primaryNormal
                : const Color(0xFFB3B3B3), // Inactive grey matching design
            shape: BoxShape.circle,
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
          Image.asset(
            data.imagePath,
            height: 360,
            width: 360,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: LivestTypography.displayLg.copyWith(
                color: LivestColors.textPrimary,
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
              style: LivestTypography.bodyMd.copyWith(
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
