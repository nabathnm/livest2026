import 'package:livest/core/data/models/chat_model.dart';
import 'package:livest/features/breader/chatbot/services/chat_service.dart';

class ChatRepository {
  final ChatService _service;

  ChatRepository(this._service);

  Future<ChatMessageModel> sendMessage(String userMessage) async {
    try {
      final rawText = await _service.sendMessage(userMessage);

      if (rawText.trim().isEmpty) {
        return ChatMessageModel(
          role: 'bot',
          text: 'Maaf, saya tidak mendapat respons. Coba ulangi pertanyaan kamu.',
        );
      }

      return ChatMessageModel(role: 'bot', text: rawText);
    } on Exception catch (e) {
      return ChatMessageModel(
        role: 'bot',
        text: _mapErrorToMessage(e),
      );
    }
  }

  void resetSession() {
    _service.resetSession();
  }

  String _mapErrorToMessage(Exception e) {
    final msg = e.toString().toLowerCase();

    if (msg.contains('network') || msg.contains('socket') || msg.contains('connection')) {
      return 'Tidak ada koneksi internet. Periksa jaringan kamu dan coba lagi.';
    }
    if (msg.contains('quota') || msg.contains('rate limit') || msg.contains('429')) {
      return 'Layanan AI sedang sibuk. Tunggu sebentar lalu coba lagi.';
    }
    if (msg.contains('api key') || msg.contains('unauthorized') || msg.contains('403')) {
      return 'Konfigurasi layanan bermasalah. Hubungi tim Livest.';
    }
    if (msg.contains('timeout')) {
      return 'Permintaan timeout. Periksa koneksi dan coba lagi.';
    }

    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}