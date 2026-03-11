import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:livest/core/config/app_config.dart';
import 'package:livest/core/config/app_config.dart';
import 'package:livest/core/data/models/chat_model.dart';

/// Service untuk komunikasi dengan Gemini AI.
/// Mengelola model & session, provider hanya delegasi ke sini.
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
        "JIKA user mencari LOKASI dunya nyata (seperti klinik hewan atau toko pakan), buatkan Link Markdown cerdas ke Google Maps seperti ini: [Buka di Google Maps](https://www.google.com/maps/search/dokter+hewan+terdekat+di+kota+anda) tanpa memanggil tool pencarian data internal. "
        "PENTING: JIKA user bertanya spesifik tentang REKOMENDASI OBAT, PAKAN, HARGA, atau TOKO di kota manapun di INDONESIA, BARU gunakan tool `search_livest_products` yang mengambil data toko/harga riil dari database nasional Livest. (Lebih baik sertakan nama kota dalam pemanggilan query ke tool agar akurat). "
        "Saat memberikan rekomendasi obat dari tool, sebutkan nama obat, fungsi, kisaran HARGA, dan NAMA TOKO beserta LOKASINYA.",
      ),
      tools: [
        Tool(
          functionDeclarations: [
            FunctionDeclaration(
              'search_livest_products',
              'Cari produk nyata (obat, pakan, ternak) yang dijual oleh peternak lain di database aplikasi Livest. Gunakan ini JIKA user mencari obat/pakan ternak beserta harganya.',
              Schema(
                SchemaType.object,
                properties: {
                  'query': Schema(
                    SchemaType.string,
                    description:
                        'Kata kunci pencarian obat atau pakan, contoh: "Obat Sapi Mencret", "Pakan Ayam Petelur"',
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

  get LocalSearchService => null;

  /// Kirim pesan ke Gemini dan tangani jika ada FunctionCall
  Future<ChatMessageModel> sendMessage(String prompt) async {
    // 1. Send the initial prompt
    var response = await _chat.sendMessage(Content.text(prompt));

    // 2. Loop as long as Gemini decides it needs to call a function
    while (response.functionCalls.isNotEmpty) {
      final functionCalls = response.functionCalls.toList();
      final List<FunctionResponse> functionResponses = [];

      for (var fCall in functionCalls) {
        if (fCall.name == 'search_livest_products') {
          // Extract the argument
          final args = fCall.args;
          final query = args['query'] as String? ?? 'Obat';

          // Execute Local Dummy Database Search (Offline & Free)
          final result = await LocalSearchService.searchProducts(query);

          // Package the result into a FunctionResponse
          functionResponses.add(FunctionResponse(fCall.name, result));
        } else {
          // Unknown function
          functionResponses.add(
            FunctionResponse(fCall.name, {"error": "Function not implemented"}),
          );
        }
      }

      // 3. Send the function result(s) back to Gemini
      response = await _chat.sendMessage(
        Content.functionResponses(functionResponses),
      );
    }

    // 4. Once the loop ends, we have the final text response
    return ChatMessageModel(
      role: 'bot',
      text: response.text ?? 'Tidak ada respon.',
    );
  }

  /// Reset session chat
  void resetSession() {
    _chat = _model.startChat();
  }
}
