// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Optionally pre-seed a system message
    final provider = context.read<ChatProvider>();
    if (provider.messages.isEmpty) {
      provider.addSystemMessage(
        "Hi — I'm GeoSafe. Ask about disaster preparedness or type a question.",
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSend(ChatProvider provider) async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _controller.clear();
    await provider.sendUserMessage(text);
    _scrollToBottom();
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GeoSafe Assistant'), elevation: 0),
      body: SafeArea(
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToBottom(),
            );
            final messages = chatProvider.messages;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      if (m.isTyping) {
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: TypingIndicator(),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: m.sender == Sender.user
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            ChatBubble(message: m),
                            const SizedBox(height: 4),
                            Padding(
                              padding: m.sender == Sender.user
                                  ? const EdgeInsets.only(right: 6)
                                  : const EdgeInsets.only(left: 6),
                              child: Text(
                                DateFormat.Hm().format(m.createdAt),
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Input area with floating style
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.sentiment_satisfied_outlined,
                                ),
                                onPressed: () {},
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  minLines: 1,
                                  maxLines: 5,
                                  textInputAction: TextInputAction.send,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Ask about preparedness, e.g., 'What to do during a flood?'",
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => _handleSend(chatProvider),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.attach_file_outlined),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: () => _handleSend(chatProvider),
                        mini: true,
                        child: _isSending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
