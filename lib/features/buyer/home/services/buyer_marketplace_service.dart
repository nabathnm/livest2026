import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuyerMarketplaceService {
  final _supabaseClient = Supabase.instance.client;

  Future<List<ProductModel>> getProduct() async {
    final response = await _supabaseClient
        .from('products')
        .select()
        .eq('is_sold', false)
        .limit(20);
    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
