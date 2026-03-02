import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/widgets/custom_button.dart';

// Data model for each onboarding page
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

// All onboarding pages data in one place
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
        'Dapatkan rekomendasi cerdas berbasis AI untuk membantu kebutuhan peternakan Anda.',
  ),
  const OnboardingData(
    imagePath:
        'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/onBoarding3.png',
    title: 'Pantau Ternak Kapan Saja',
    description:
        'Monitor kondisi dan perkembangan ternak Anda secara real-time dari mana saja.',
  ),
];

// Main onboarding controller page — handles page navigation
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
      // TODO: navigate to home/login
    }
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _skip() {
    // TODO: navigate to home/login
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _currentIndex > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
            : null,
        actions: [
          if (!isLast)
            TextButton(
              onPressed: _skip,
              child: Text(
                'Skip',
                style: TextStyle(color: LivestColors.textSecondary),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress indicator
            _OnboardingProgressBar(
              total: onboardingPages.length,
              current: _currentIndex,
            ),
            const SizedBox(height: 56),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return _OnboardingDetail(data: onboardingPages[index]);
                },
              ),
            ),

            const SizedBox(height: 56),
            CustomButton(text: isLast ? 'Mulai' : 'Lanjut', onPressed: _goNext),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Progress bar widget
class _OnboardingProgressBar extends StatelessWidget {
  final int total;
  final int current;

  const _OnboardingProgressBar({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? LivestColors.primaryNormal
                  : LivestColors.primaryNormal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

// Reusable detail widget — driven entirely by OnboardingData
class _OnboardingDetail extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingDetail({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Image.network(
          data.imagePath,
          height: 360,
          width: 360,
          fit: BoxFit.contain,
        ),
        // Container(height: 360, width: 360, color: LivestColors.primaryDark),
        Column(
          spacing: 24,
          children: [
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: LivestColors.textPrimary,
                height: 1.25,
              ),
            ),
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: LivestColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
