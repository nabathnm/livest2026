import 'package:flutter/material.dart';
import 'package:livest/core/data/models/chat_model.dart';
import 'package:livest/features/breader/ai/services/chat_service.dart';

/// Provider untuk mengelola state chat AI.
/// Delegasi semua logic AI ke ChatService (SRP).
class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  /// Kirim pesan ke Gemini via ChatService
  Future<void> sendMessage(String userMessage) async {
    _messages.add(ChatMessageModel(role: 'user', text: userMessage));
    _isLoading = true;
    notifyListeners();

    try {
      final botReply = await _chatService.sendMessage(userMessage);
      _messages.add(botReply);
    } catch (e) {
      _messages.add(
        ChatMessageModel(role: 'bot', text: 'Terjadi kesalahan: $e'),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Bersihkan riwayat chat
  void clearChat() {
    _messages.clear();
    _chatService.resetSession();
    notifyListeners();
  }
}
