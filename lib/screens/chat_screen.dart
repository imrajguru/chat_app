import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';
import '../services/voice_service.dart';
import '../services/chat_storage_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  final AiService _aiService = AiService();
  final VoiceService _voiceService = VoiceService();
  final ChatStorageService _storageService = ChatStorageService();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    final savedMessages = await _storageService.loadMessages();
    setState(() => _messages = savedMessages);
  }

  Future<void> _saveChatHistory() async {
    await _storageService.saveMessages(_messages);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _controller.clear();
    await _saveChatHistory();

    try {
      final aiReply = await _aiService.getAiResponse(text);

      setState(() {
        _messages.add(
          ChatMessage(
            text: aiReply,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (_) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "⚠️ AI service unavailable.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      _isLoading = false;
      await _saveChatHistory();
      setState(() {});
    }
  }

  Future<void> _handleVoiceInput() async {
    final available = await _voiceService.initialize();
    if (!available) return;

    setState(() => _isListening = true);

    _voiceService.startListening((text) {
      _controller.text = text;
    });

    await Future.delayed(const Duration(seconds: 4));
    _voiceService.stopListening();

    setState(() => _isListening = false);
    _sendMessage(_controller.text);
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Chat Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _storageService.clearMessages();
              setState(() => _messages.clear());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, index) =>
                  _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.black,
                ),
                onPressed: _isListening ? null : _handleVoiceInput,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Type or speak...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed:
                    _isLoading ? null : () => _sendMessage(_controller.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
