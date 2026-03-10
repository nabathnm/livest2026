import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSearchService {
  static final _supabase = Supabase.instance.client;

  /// Mencari produk (pakan, obat, ternak) di database Supabase
  static Future<Map<String, dynamic>> searchProducts(String query) async {
    try {
      // Kita gunakan `ilike` untuk mencari substring (case-insensitive) di nama atau deskripsi
      final response = await _supabase
          .from('products')
          .select('name, price, description, type, location')
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_sold', false) // Hanya cari yang belum terjual
          .limit(5); // Batasi hasil max 5 agar AI tidak overheat token

      final List<dynamic> data = response;

      if (data.isEmpty) {
        return {
          "status": "SUCCESS",
          "message": "Tidak ada obat atau pakan yang cocok untuk query: $query"
        };
      }

      return {
        "status": "SUCCESS",
        "results": data,
      };
    } catch (e) {
      return {
        "status": "ERROR",
        "message": "Gagal mengambil data dari database Supabase: $e",
      };
    }
  }
}
