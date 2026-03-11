import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:livest/features/breader/marketplace/models/product_model.dart';

class CartService {
  final _supabaseClient = Supabase.instance.client;

  // Get buyer cart
  Future<List<ProductModel>> getCartItems(String userId) async {
    final response = await _supabaseClient
        .from('cart_items')
        .select('products(*)')
        .eq('user_id', userId.trim())
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => ProductModel.fromJson(e['products']))
        .toList();
  }

  /// Add product to cart
  Future<void> addToCart(String userId, int productId) async {
    // final user = _supabaseClient.auth.currentUser;
    await _supabaseClient.from('cart_items').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  /// Delete product from cart
  Future<void> removeFromCart(String userId, int productId) async {
    await _supabaseClient
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  /// Cek apakah produk sudah ada di cart
  Future<bool> isProductInCart(String userId, int productId) async {
    final response = await _supabaseClient
        .from('cart_items')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();
    return response != null;
  }
}
