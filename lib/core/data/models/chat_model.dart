class ChatMessageModel {
  final String role; 
  final String text;
  final DateTime timestamp;

  ChatMessageModel({
    required this.role,
    required this.text,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  bool get isUser => role == 'user';
  bool get isBot => role == 'bot';
}
