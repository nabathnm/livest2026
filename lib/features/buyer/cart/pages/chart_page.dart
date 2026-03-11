import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/auth/providers/profile_provider.dart';
import 'package:livest/features/buyer/cart/pages/widgets/cart_card.dart';
import 'package:livest/features/buyer/cart/providers/cart_provider.dart';
import 'package:livest/features/buyer/home/pages/detail_product_page.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String get _userId => context.read<ProfileProvider>().id ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = context.read<ProfileProvider>().id;
      if (id != null && id.isNotEmpty) {
        context.read<CartProvider>().loadCart(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseBackground,
      appBar: AppBar(
        backgroundColor: LivestColors.baseBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset("assets/images/icon/cart.png"),
            const SizedBox(width: 16),
            Text(
              'Keranjang',
              style: LivestTypography.displaySm.copyWith(
                color: LivestColors.primaryDarker,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: LivestColors.primaryNormal,
              ),
            );
          }

          if (cart.cartItems.isEmpty) {
            return Center(
              child: SizedBox(
                width: 192,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/mascot/empty.png"),
                    const SizedBox(height: 12),
                    Text(
                      "Keranjang masih kosong, yuk belanja!",
                      textAlign: TextAlign.center,
                      style: LivestTypography.bodyMdSemiBold.copyWith(
                        color: const Color(0xFF5C3A1E),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            itemCount: cart.cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = cart.cartItems[index];

              return CartCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailProductPage(product: product),
                    ),
                  );
                },
                onDelete: () {
                  if (_userId.isNotEmpty) {
                    cart.removeFromCart(_userId, product);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
