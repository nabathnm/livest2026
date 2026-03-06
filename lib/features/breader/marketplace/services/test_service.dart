import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class TestService {
  final _supabaseClient = Supabase.instance.client;

  Future<List<ProductModel>> getMyProduct(String userId) async {
    final response = await _supabaseClient
        .from('products')
        .select()
        .eq('user_id', userId.trim());
    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await _supabaseClient
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    return ProductModel.fromJson(response);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _supabaseClient
        .from('products')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  Future<void> deleteProduct(int productId) async {
    await _supabaseClient.from('products').delete().eq('id', productId);
  }
}
