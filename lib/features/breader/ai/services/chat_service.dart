import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:livest/core/config/app_config.dart';
import 'package:livest/data/models/chat_model.dart';

/// Service untuk komunikasi dengan Gemini AI.
/// Mengelola model & session, provider hanya delegasi ke sini.
class ChatService {
  late final GenerativeModel _model;
  late ChatSession _chat;

  ChatService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: AppConfig.geminiApiKey,
    );
    _chat = _model.startChat();
  }

  /// Kirim pesan ke Gemini dan kembalikan ChatMessageModel balasan
  Future<ChatMessageModel> sendMessage(String prompt) async {
    final response = await _chat.sendMessage(
      Content.text(
        "Sampaikan dalam 1 paragraf terdiri maksimal 3 kalimat pendek: $prompt",
      ),
    );

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
