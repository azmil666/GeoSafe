// lib/providers/chat_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService api;
  final List<Message> _messages = [];
  final Uuid _uuid = const Uuid();

  List<Message> get messages => List.unmodifiable(_messages);

  ChatProvider({required this.api});

  void addSystemMessage(String text) {
    _messages.add(Message(id: _uuid.v4(), text: text, sender: Sender.system));
    notifyListeners();
  }

  Future<void> sendUserMessage(String text) async {
    final userMsg = Message(id: _uuid.v4(), text: text, sender: Sender.user);
    _messages.add(userMsg);

    // Add typing indicator (AI)
    final typingMsg = Message(
      id: 'typing-${_uuid.v4()}',
      text: '',
      sender: Sender.ai,
      isTyping: true,
    );
    _messages.add(typingMsg);
    notifyListeners();

    try {
      final reply = await api.sendMessage(text);

      // replace typing message with actual AI response
      final index = _messages.indexWhere((m) => m.id == typingMsg.id);
      if (index >= 0) {
        _messages[index] = Message(
          id: _uuid.v4(),
          text: reply,
          sender: Sender.ai,
        );
      } else {
        _messages.add(Message(id: _uuid.v4(), text: reply, sender: Sender.ai));
      }
    } catch (e) {
      // Replace typing with error message
      final index = _messages.indexWhere((m) => m.id == typingMsg.id);
      final errText = "Error contacting backend: ${e.toString()}";
      if (index >= 0) {
        _messages[index] = Message(
          id: _uuid.v4(),
          text: errText,
          sender: Sender.ai,
        );
      } else {
        _messages.add(
          Message(id: _uuid.v4(), text: errText, sender: Sender.ai),
        );
      }
    }

    notifyListeners();
  }
}
