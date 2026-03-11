import 'package:flutter/material.dart';
import 'package:livest/core/utils/widgets/livest_skeleton.dart';

/// Skeleton loading layout untuk Pembeli HomePage
/// Didesain agar mengikuti struktur UI pembeli saat ini.
class BuyerHomeSkeleton extends StatelessWidget {
  const BuyerHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (Avatar + Title + Search Bar) ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const LivestSkeleton(
                      width: 36,
                      height: 36,
                      shape: BoxShape.circle,
                    ),
                    const SizedBox(width: 8),
                    const LivestSkeleton(width: 150, height: 16),
                  ],
                ),
                const SizedBox(height: 16),
                const LivestSkeleton(
                  width: double.infinity,
                  height: 56,
                  borderRadius: 90,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ── Category Chips ──
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: List.generate(
                3,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: LivestSkeleton(width: 80, height: 32, borderRadius: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Banner ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                LivestSkeleton(
                  width: double.infinity,
                  height: 140,
                  borderRadius: 16,
                ),
                SizedBox(height: 16),
                LivestSkeleton(width: 180, height: 20), // "Harga Pasar Ternak"
                SizedBox(height: 16),
              ],
            ),
          ),

          // ── Category Items Scrollable ──
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: List.generate(
                3,
                (_) => const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: LivestSkeleton(width: 100, height: 120, borderRadius: 12),
                ),
              ),
            ),
          ),

          // ── Product Grid ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LivestSkeleton(width: 100, height: 20), // "Untukmu"
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: LivestSkeleton(height: 220, borderRadius: 16)),
                    SizedBox(width: 16),
                    Expanded(child: LivestSkeleton(height: 220, borderRadius: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: LivestSkeleton(height: 220, borderRadius: 16)),
                    SizedBox(width: 16),
                    Expanded(child: LivestSkeleton(height: 220, borderRadius: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
