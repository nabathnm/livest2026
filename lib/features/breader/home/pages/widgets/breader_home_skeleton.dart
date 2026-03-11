import 'package:flutter/material.dart';
import 'package:livest/core/utils/widgets/livest_skeleton.dart';

/// Skeleton loading layout untuk Peternak HomePage
/// Didesain persis sesuai wireframe `dashboardPeternak/start`.
class BreaderHomeSkeleton extends StatelessWidget {
  const BreaderHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Memberikan SingleChildScrollView agar transisi aman dengan halaman aslinya
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Section (Avatar + Titles)
            Row(
              children: [
                const LivestSkeleton(
                  width: 48,
                  height: 48,
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Title panjang (Selamat datang)
                    LivestSkeleton(width: 150, height: 16),
                    SizedBox(height: 8),
                    // Subtitle pendek (Peternakan ABC)
                    LivestSkeleton(width: 100, height: 14),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 2. Main Banner Skeleton (Kotak besar memanjang)
            const LivestSkeleton(
              width: double.infinity,
              height: 120,
              borderRadius: 16,
            ),
            const SizedBox(height: 32),

            // 3. Section Title 1 (Misal: Edukasi)
            const LivestSkeleton(width: 120, height: 16, borderRadius: 8),
            const SizedBox(height: 16),

            // 4. Horizontal Menu (4 kotak dengan rounded corner)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: LivestSkeleton(
                      height: 80,
                      borderRadius: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 5. Section Title 2 (Misal: Partner Khusus / Lainnya)
            const LivestSkeleton(width: 140, height: 16, borderRadius: 8),
            const SizedBox(height: 16),

            // 6. Horizontal Menu (3 lingkaran besar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) => const LivestSkeleton(
                  width: 70,
                  height: 70,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 7. Section Title 3 (Misal: Rekomendasi)
            const LivestSkeleton(width: 130, height: 16, borderRadius: 8),
            const SizedBox(height: 16),

            // 8. Grid view 2 kolom (Card Rekomendasi)
            Row(
              children: [
                Expanded(
                  child: const LivestSkeleton(
                    height: 180,
                    borderRadius: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: const LivestSkeleton(
                    height: 180,
                    borderRadius: 16,
                  ),
                ),
              ],
            ),
            // Beri jarak ekstra di bawah
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
