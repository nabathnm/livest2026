import 'package:livest/core/data/dummy_livestock_data.dart';

class LocalSearchService {
  /// Mencari produk (pakan, obat, layanan hewan) secara lokal di memori
  static Future<Map<String, dynamic>> searchProducts(String query) async {
    // Simulasi delay jaringan agar terasa natural (opsional)
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();

    // Filter daftar dummy lokal yang namanya atau deskripsinya mengandung kata kunci
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

    // Batasi maksimum 5 hasil agar tidak memberatkan token Gemini
    final limitedResults = results.take(5).toList();

    return {"status": "SUCCESS", "results": limitedResults};
  }
}
