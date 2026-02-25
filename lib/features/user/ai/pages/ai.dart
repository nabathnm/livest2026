import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiChatApp extends StatelessWidget {
  const GeminiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  // Masukkan API Key Anda di sini
  static const String _apiKey = 'AIzaSyAA8tHrkiO6-0bkStLRjWVxBoBvW_sPgW8';

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    // Inisialisasi model dan sesi chat agar punya memori percakapan
    _model = GenerativeModel(model: 'gemini-3-flash-preview', apiKey: _apiKey);
    _chat = _model.startChat();
  }

  Future<void> _sendChat() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _isLoading = true;
    });
    _controller.clear();

    try {
      // Mengirim pesan ke Gemini
      final response = await _chat.sendMessage(
        Content.text(
          "sampaikan dalam 1 paragraf terdiri maksimal 3 kalimat pendek:" +
              userMessage,
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasikan masalah ternak')),
      body: Column(
        children: [
          // Area Menampilkan Chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      msg['text']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading) const LinearProgressIndicator(),

          // Area Input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tanya sesuatu...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _isLoading ? null : _sendChat,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
