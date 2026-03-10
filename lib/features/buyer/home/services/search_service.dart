import 'package:livest/features/breader/marketplace/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchService {
  final _client = Supabase.instance.client;

  Future<List<ProductModel>> searchProducts(String query) async {
    final q = query.trim();

    if (q.isEmpty) return [];

    final response = await _client
        .from('products')
        .select()
        .or('name.ilike.*$q*,description.ilike.*$q*,type.ilike.*$q*')
        .eq('is_sold', false)
        .order('created_at', ascending: false)
        .limit(30);

    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
