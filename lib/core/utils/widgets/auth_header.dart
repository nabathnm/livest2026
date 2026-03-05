import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';

/// Brown header section di atas halaman Masuk/Daftar.
/// Sesuai design: background coklat, "Selamat datang!", subtitle, tab switcher.
class AuthHeader extends StatelessWidget {
  final String subtitle;
  final int activeTab; // 0 = Masuk, 1 = Daftar
  final ValueChanged<int>? onTabChanged;

  /// Untuk halaman non-login (OTP, Lupa Password) — tanpa tabs
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
    // Non-login mode (OTP, Lupa Password, etc.)
    if (!showTabs) {
      return Column(
        children: [
          if (icon != null) ...[
            const SizedBox(height: LivestSizes.lg),
          ],
          Text(
            title ?? "",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: LivestColors.textHeading,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: LivestSizes.sm),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // Login/Register mode — brown header + tabs
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      decoration: const BoxDecoration(
        color: LivestColors.primaryNormal,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Selamat datang!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: LivestColors.baseWhite,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              color: LivestColors.baseWhite.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: LivestSizes.lg),

          // Tab switcher
          Container(
            decoration: BoxDecoration(
              color: LivestColors.primaryDark,
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
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged?.call(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? LivestColors.baseWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: LivestSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? LivestColors.primaryNormal
                  : LivestColors.baseWhite,
            ),
          ),
        ),
      ),
    );
  }
}
