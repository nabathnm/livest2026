import 'package:flutter/material.dart';
import 'package:livest/core/data/models/chat_model.dart';
import 'package:livest/features/breader/chatbot/repository/chat_repository.dart';
import 'package:livest/features/breader/chatbot/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;
  ChatProvider() : _repository = ChatRepository(ChatService());

  final List<ChatMessageModel> _messages = [];
  bool _isLoading = false;

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String userMessage) async {
    _messages.add(ChatMessageModel(role: 'user', text: userMessage));
    _isLoading = true;
    notifyListeners();

    final botReply = await _repository.sendMessage(userMessage);
    _messages.add(botReply);

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _repository.resetSession();
    notifyListeners();
  }
}