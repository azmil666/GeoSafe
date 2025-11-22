// lib/models/message.dart

enum Sender { user, ai, system }

class Message {
  final String id;
  final String text;
  final Sender sender;
  final DateTime createdAt;
  final bool isTyping; // used to show typing/loading bubble

  Message({
    required this.id,
    required this.text,
    required this.sender,
    DateTime? createdAt,
    this.isTyping = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Message copyWith({
    String? id,
    String? text,
    Sender? sender,
    DateTime? createdAt,
    bool? isTyping,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}
