import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:livest/core/config/app_config.dart';
import 'package:livest/core/utils/constants/livest_colors.dart';

class GeminiChatApp extends StatelessWidget {
  const GeminiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ChatScreen(),
    );
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
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: AppConfig.geminiApiKey,
    );
    _chat = _model.startChat();
  }

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

  Future<void> _sendChat() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _chat.sendMessage(
        Content.text(
          "Jawab pertanyaan berikut dalam tepat 1 paragraf, "
          "maksimal 3 kalimat pendek, tanpa bullet point, "
          "tanpa judul, tanpa penomoran, hanya teks biasa: $text",
        ),
      );
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': response.text ?? 'Tidak ada respon.',
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'text': 'Terjadi kesalahan: $e'});
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LivestColors.primaryLight,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          if (_isLoading) _buildTypingIndicator(),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: LivestColors.primaryLight,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: 56,
      leadingWidth: 72,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: LivestColors.primaryLightHover,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chevron_left_rounded,
              color: LivestColors.primaryNormal,
              size: 26,
            ),
          ),
        ),
      ),
      title: const Text(
        'Chatbot',
        style: TextStyle(
          color: LivestColors.textHeading,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  // ─── Message List ─────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    if (_messages.isEmpty) return _buildEmptyState();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return msg['role'] == 'user'
            ? _buildUserBubble(msg['text']!)
            : _buildBotMessage(msg['text']!);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: LivestColors.primaryLightHover,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: LivestColors.primaryNormal,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tanyakan apapun\ntentang ternak kamu',
            textAlign: TextAlign.center,
            style: TextStyle(color: LivestColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ─── Bubbles ──────────────────────────────────────────────────────────────

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: LivestColors.primaryLightActive,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: LivestColors.textHeading,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ),
    );
  }

  Widget _buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 48),
        child: Text(
          text,
          style: const TextStyle(
            color: LivestColors.textPrimary,
            fontSize: 15,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  // ─── Typing Indicator ─────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: LivestColors.primaryLightHover,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: List.generate(3, (i) => _buildDot(i)),
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 150),
      builder: (_, value, __) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          color: LivestColors.primaryNormal.withOpacity(0.4 + 0.6 * value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // ─── Input Bar ────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Container(
      color: LivestColors.primaryLight,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: LivestColors.baseWhite,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: LivestColors.primaryLightActive,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(
                      color: LivestColors.textPrimary,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Apa yang ingin kamu tanyakan?',
                      hintStyle: TextStyle(
                        color: LivestColors.textSecondary.withOpacity(0.6),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(20, 14, 0, 14),
                    ),
                    onSubmitted: (_) => _sendChat(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: GestureDetector(
                    onTap: _isLoading ? null : _sendChat,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _isLoading
                            ? LivestColors.primaryLightActive
                            : LivestColors.primaryNormal,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.send_rounded,
                        color: LivestColors.baseWhite,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Chatbot adalah AI dan dapat membuat kesalahan.',
            style: TextStyle(
              fontSize: 12,
              color: LivestColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
