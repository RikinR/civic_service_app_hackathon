import 'package:civic_service_app/service/gemini_service.dart';
import 'package:flutter/material.dart';

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final GeminiService geminiService = GeminiService(
    "AIzaSyBAJbubgfm6dHQgYMRxSAMl9JfiFXrL9oY",
  ); // 🔑 Replace with your key
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {"isUser": false, "text": "Hello! 👋 I'm Jan Seva. How can I help you?"},
  ];

  bool isLoading = false;

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      messages.add({"isUser": true, "text": userText});
      isLoading = true;
      _controller.clear();
    });

    final reply = await geminiService.sendMessage(userText);

    setState(() {
      messages.add({
        "isUser": false,
        "text": reply ?? "⚠️ Sorry, something went wrong. Please try again.",
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.tertiary.withAlpha(175),
              colorScheme.primary.withAlpha(50),
              colorScheme.primary.withAlpha(25),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Text(
                    "Chat with Indore Sahayak",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),

              // Chat messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message["isUser"] as bool;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? colorScheme.primary.withAlpha(200)
                              : colorScheme.secondary.withAlpha(200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message["text"].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),

              // Message input field
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                color: Colors.white.withAlpha(225),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
