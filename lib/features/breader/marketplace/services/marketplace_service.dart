import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class MarketplaceService {
  final _supabaseClient = Supabase.instance.client;

  // Get breader product
  Future<List<ProductModel>> getMyProduct(String userId) async {
    final response = await _supabaseClient
        .from('products')
        .select()
        .eq('user_id', userId.trim());
    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  // Create product
  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await _supabaseClient
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    return ProductModel.fromJson(response);
  }

  // Update product
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _supabaseClient
        .from('products')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  // Delete product
  Future<void> deleteProduct(int productId) async {
    await _supabaseClient.from('products').delete().eq('id', productId);
  }

  // Make product sold
  Future<void> markProductAsSold(int productId) async {
    await _supabaseClient
        .from('products')
        .update({'is_sold': true})
        .eq('id', productId);
  }
}
