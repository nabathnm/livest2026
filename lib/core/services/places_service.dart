import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livest/core/config/app_config.dart';

class PlacesService {
  /// Mencari tempat terdekat menggunakan Google Places API (Text Search)
  static Future<Map<String, dynamic>> searchPlaces(String query) async {
    final apiKey = AppConfig.googleMapsApiKey;
    
    if (apiKey.isEmpty) {
      return {
        "status": "ERROR",
        "message": "GOOGLE_MAPS_API_KEY belum dikonfigurasi di file .env."
      };
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Return max 3 results to save tokens
        List<dynamic> results = data['results'] ?? [];
        if (results.length > 3) {
          results = results.sublist(0, 3);
        }

        // Extract meaningful data
        final simplifiedResults = results.map((place) {
          return {
            "name": place['name'],
            "address": place['formatted_address'],
            "rating": place['rating'],
            "user_ratings_total": place['user_ratings_total'],
            // Jika ada info status buka tutup
            "open_now": place['opening_hours']?['open_now'],
          };
        }).toList();

        return {
          "status": "SUCCESS",
          "results": simplifiedResults,
        };
      } else {
        return {
          "status": "API_ERROR",
          "message": "Gagal menghubungi Google Maps API: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "status": "EXCEPTION",
        "message": e.toString(),
      };
    }
  }
}
