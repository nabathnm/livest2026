import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:livest/core/config/app_config.dart';
import 'package:livest/core/services/local_search_service.dart';

class ChatService {
  late final GenerativeModel _model;
  late ChatSession _chat;

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.system(
        "Kamu adalah Livest AI, asisten virtual dan ahli di bidang peternakan (livestock) yang cerdas, ramah, dan berpengetahuan luas tentang hewan ternak (sapi, kambing, ayam, domba, dll). "
        "Fokus keahlianmu: penyakit ternak, nutrisi/pakan ternak, manajemen kandang, dan pemeliharaan ternak secara umum. "
        "Gunakan format point/list (Markdown) bila perlu agar jawaban mudah dibaca. "
        "JIKA user mencari LOKASI dunia nyata (seperti klinik hewan atau toko pakan), buatkan Link Markdown cerdas ke Google Maps seperti ini: [Buka di Google Maps](https://www.google.com/maps/search/dokter+hewan+terdekat+di+kota+anda) tanpa memanggil tool pencarian data internal. "
        "PENTING: JIKA user bertanya spesifik tentang REKOMENDASI OBAT, PAKAN, HARGA, atau TOKO di kota manapun di INDONESIA, BARU gunakan tool `search_livest_products` yang mengambil data toko/harga riil dari database nasional Livest. "
        "Saat memberikan rekomendasi obat dari tool, sebutkan nama obat, fungsi, kisaran HARGA, dan NAMA TOKO beserta LOKASINYA.",
      ),
      tools: [
        Tool(
          functionDeclarations: [
            FunctionDeclaration(
              'search_livest_products',
              'Cari produk nyata (obat, pakan, ternak) yang dijual oleh peternak lain di database aplikasi Livest.',
              Schema(
                SchemaType.object,
                properties: {
                  'query': Schema(
                    SchemaType.string,
                    description: 'Kata kunci pencarian obat atau pakan, contoh: "Obat Sapi Mencret"',
                  ),
                },
                requiredProperties: ['query'],
              ),
            ),
          ],
        ),
      ],
    );
    _chat = _model.startChat();
  }

  Future<String> sendMessage(String prompt) async {
    var response = await _chat.sendMessage(Content.text(prompt));

    while (response.functionCalls.isNotEmpty) {
      final functionCalls = response.functionCalls.toList();
      final List<FunctionResponse> functionResponses = [];

      for (var fCall in functionCalls) {
        if (fCall.name == 'search_livest_products') {
          final query = fCall.args['query'] as String? ?? '';
          final result = await LocalSearchService.searchProducts(query);
          functionResponses.add(FunctionResponse(fCall.name, result));
        } else {
          functionResponses.add(
            FunctionResponse(fCall.name, {"error": "Function not implemented"}),
          );
        }
      }

      response = await _chat.sendMessage(
        Content.functionResponses(functionResponses),
      );
    }

    return response.text ?? '';
  }

  void resetSession() {
    _chat = _model.startChat();
  }
}