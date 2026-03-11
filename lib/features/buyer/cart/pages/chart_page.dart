import 'package:flutter/material.dart';
import 'package:livest/core/utils/constants/livest_typography.dart';
import 'package:livest/features/buyer/cart/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final String userId = "4057b852-9814-4c12-b0bc-616ff0cf8077";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CartProvider>().loadCart(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keranjang")),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cart.cartItems.isEmpty) {
            return Center(
              child: SizedBox(
                width: 192,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/mascot/empty.png"),
                    const SizedBox(height: 4),
                    Text(
                      "Keranjang masih kosong, yuk belanja!",
                      textAlign: TextAlign.center,
                      style: LivestTypography.bodyMdSemiBold,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: cart.cartItems.length,
            itemBuilder: (context, index) {
              final product = cart.cartItems[index];

              return ListTile(
                title: Text(product.name ?? "Product"),
                subtitle: Text("Rp ${product.price ?? 0}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    cart.removeFromCart(userId, product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
