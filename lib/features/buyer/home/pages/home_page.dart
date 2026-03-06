import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/features/buyer/home/pages/detail_product.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class RecentOrderModel {
  final String id;
  final String productName;
  final String imagePath;
  final String sellerName;
  final String status; // 'Diproses' | 'Dikirim' | 'Selesai'
  final String price;

  const RecentOrderModel({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.sellerName,
    required this.status,
    required this.price,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────

// ─── Home Page ────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/onboarding/avatar.png"),
                    Text("Selamat datang, Aziz"),
                  ],
                ),

                // ── Search bar ──
                _SearchBar(),

                // ── Banner ──
                Image.network(
                  "https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/onboarding/banner.png",
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/images/icon/sapi.png"),
                        Text("Sapi"),
                        Text("15.7 jt"),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/images/icon/sapi.png"),
                        Text("Sapi"),
                        Text("15.7 jt"),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/images/icon/kambing.png"),
                        Text("Kambing"),
                        Text("15.7 jt"),
                      ],
                    ),
                    Column(
                      children: [
                        Image.asset("assets/images/icon/ayam.png"),
                        Text("Ayam"),
                        Text("15.7 jt"),
                      ],
                    ),
                  ],
                ),

                // ── Promo Products ──
                _SectionHeader(title: 'Promo Untukmu', onSeeAll: () {}),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final String name;
  const _HomeHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $name 👋',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Mau beli ternak apa hari ini?',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
        Stack(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: LivestColors.primaryNormal.withOpacity(0.15),
              child: Icon(
                Icons.person_rounded,
                color: LivestColors.primaryNormal,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari ternak, pakan, atau peternak...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ─── Promo Banner ─────────────────────────────────────────────────────────────

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            LivestColors.primaryNormal,
            LivestColors.primaryNormal.withGreen(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'PROMO SPESIAL',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Text(
                  'Diskon hingga 30%\nuntuk produk pilihan!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.storefront_rounded,
            size: 70,
            color: Colors.white.withOpacity(0.25),
          ),
        ],
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        decoration: BoxDecoration(
          color: isActive ? LivestColors.primaryNormal : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? LivestColors.primaryNormal.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? Colors.white : Colors.grey.shade500,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            'Lihat Semua',
            style: TextStyle(
              fontSize: 13,
              color: LivestColors.primaryNormal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Recent Order Card ────────────────────────────────────────────────────────

class RecentOrderCard extends StatelessWidget {
  final RecentOrderModel order;

  const RecentOrderCard({super.key, required this.order});

  Color _statusColor(String status) {
    return switch (status) {
      'Dikirim' => Colors.blue.shade600,
      'Diproses' => Colors.orange.shade600,
      'Selesai' => Colors.green.shade600,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        spacing: 12,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              order.imagePath,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: LivestColors.primaryNormal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: LivestColors.primaryNormal,
                ),
              ),
            ),
          ),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Text(
                  order.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  order.sellerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(order.status),
                        ),
                      ),
                    ),
                    Text(
                      order.price,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: LivestColors.primaryNormal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Promo Product Card ───────────────────────────────────────────────────────
