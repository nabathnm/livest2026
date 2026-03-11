import 'package:flutter/material.dart';
import 'package:livest/features/breader/chatbot/pages/widgets/chat_message_bubble.dart';
import 'package:livest/features/breader/chatbot/pages/widgets/suggested_question_button.dart';
import 'package:livest/features/breader/chatbot/pages/widgets/typing_indicator.dart';
import 'package:provider/provider.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';
import 'package:livest/core/utils/constants/livest_sizes.dart';
import 'package:livest/features/breader/chatbot/providers/chat_provider.dart';

class GeminiChatApp extends StatelessWidget {
  const GeminiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestedQuestions = [
    "Rekomendasi pakan ternak ayam?",
    "Cara mengatasi ternak muntah?",
    "Cara mengobati kutu pada sapi?",
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatProvider provider, String text) {
    if (text.trim().isEmpty) return;
    provider.sendMessage(text.trim());
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.baseWhite,
      appBar: AppBar(
        backgroundColor: LivestColors.baseWhite,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8, bottom: 8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: const BoxDecoration(
                color: LivestColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: LivestColors.textHeading,
              ),
            ),
          ),
        ),
        title: const Text(
          'Chatbot',
          style: TextStyle(
            color: LivestColors.textHeading,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          // If a new message arrives, scroll to bottom
          if (chatProvider.messages.isNotEmpty) {
            _scrollToBottom();
          }

          return Column(
            children: [
              Expanded(
                child: chatProvider.messages.isEmpty
                    ? _buildEmptyState(chatProvider)
                    : _buildChatList(chatProvider),
              ),

              // Bottom Input Area
              _buildInputArea(chatProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(ChatProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: LivestSizes.xl * 2),
          Image.asset(
            'assets\images\mascot\sapiduduk.png',
            width: 174,
            height: 174,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: LivestColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 80,
                color: LivestColors.primaryNormal,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            "Selamat datang di Chatbot!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LivestColors.textHeading,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Tanyakan keluhan ternak, penyakit ternak, dan masalah apapun terkait ternakmu! Asisten chat cerdas kami siap membantu!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: LivestColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ..._suggestedQuestions.map(
            (q) => SuggestedQuestionButton(
              text: q,
              onTap: () {
                _controller.text = q;
                // Optionally auto-send:
                // _sendMessage(provider, q);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(ChatProvider provider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: provider.messages.length + (provider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == provider.messages.length) {
          return const TypingIndicator();
        }
        final msg = provider.messages[index];
        return ChatMessageBubble(text: msg.text, isUser: msg.isUser);
      },
    );
  }

  Widget _buildInputArea(ChatProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(color: LivestColors.baseWhite),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: LivestColors.baseWhite,
              border: Border.all(
                color: LivestColors.primaryLightActive,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      fontSize: LivestSizes.fontSizeSm,
                      color: LivestColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Apa yang ingin kamu tanyakan?",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: LivestSizes.fontSizeSm,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (val) => _sendMessage(provider, val),
                  ),
                ),
                InkWell(
                  onTap: provider.isLoading
                      ? null
                      : () => _sendMessage(provider, _controller.text),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send_outlined,
                      color: LivestColors.textHeading,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Chatbot adalah AI dan dapat membuat kesalahan.",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
