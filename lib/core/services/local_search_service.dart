import 'package:livest/core/data/dummy_livestock_data.dart';

class LocalSearchService {
  static Future<Map<String, dynamic>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();
    final results = dummyLivestockProducts.where((product) {
      final name = (product['name'] as String).toLowerCase();
      final desc = (product['description'] as String).toLowerCase();
      final type = (product['type'] as String).toLowerCase();
      final location = (product['location'] as String).toLowerCase();

      return name.contains(lowerQuery) ||
          desc.contains(lowerQuery) ||
          type.contains(lowerQuery) ||
          location.contains(lowerQuery);
    }).toList();

    if (results.isEmpty) {
      return {
        "status": "SUCCESS",
        "message":
            "Tidak ada obat, pakan, atau layanan yang cocok dengan kata kunci: $query di wilayah tersebut. Coba kata kunci atau lokasi lain.",
      };
    }
    final limitedResults = results.take(5).toList();

    return {"status": "SUCCESS", "results": limitedResults};
  }
}
