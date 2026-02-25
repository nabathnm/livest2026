import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static const _apiKey = 'AIzaSyAA8tHrkiO6-0bkStLRjWVxBoBvW_sPgW8';

  // Inisialisasi model
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  // Fungsi untuk mengirim pesan
  Future<String> sendMessage(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text ?? 'Maaf, saya tidak bisa merespon.';
  }
}
