import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';

class AuthHeader extends StatelessWidget {
  final String subtitle;
  final int activeTab; 
  final ValueChanged<int>? onTabChanged;
  final String? title;
  final IconData? icon;
  final bool showTabs;

  const AuthHeader({
    super.key,
    required this.subtitle,
    this.activeTab = 0,
    this.onTabChanged,
    this.title,
    this.icon,
    this.showTabs = true,
    bool showLogo = false,
    bool showBrandName = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showTabs) {
      return Column(
        children: [
          if (icon != null) ...[
            const SizedBox(height: LivestSizes.lg),
          ],
          Text(
            title ?? "",
            style: LivestTypography.displaySm.copyWith(color: LivestColors.textHeading),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LivestSizes.sm),
          Text(
            subtitle,
            style: LivestTypography.bodySm.copyWith(color: LivestColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      children: [
        Image.asset(
          'assets/images/login/Header.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(height: LivestSizes.md),
        
        Text(
          "Selamat datang!",
          style: LivestTypography.displayMd.copyWith(color: LivestColors.textHeading),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: LivestTypography.bodySm.copyWith(color: LivestColors.textSecondary),
        ),
        const SizedBox(height: LivestSizes.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LivestSizes.lg),
          child: Container(
            decoration: BoxDecoration(
              color: LivestColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _buildTab("Masuk", 0),
                _buildTab("Daftar", 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged?.call(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? LivestColors.primaryNormal : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: LivestTypography.bodySmBold.copyWith(
              color: isActive
                  ? LivestColors.baseWhite
                  : LivestColors.textHeading,
            ),
          ),
        ),
      ),
    );
  }
}
