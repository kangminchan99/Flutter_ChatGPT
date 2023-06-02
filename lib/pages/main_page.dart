import 'package:chatgpt/component/gpt_service.dart';
import 'package:chatgpt/controller/gpt_controller.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GptController gptController = GptController();
  GptService gptService = GptService();
  final List<String> _chatLog = [];
  void update() => setState(() {});

  void sendMessage(String message) async {
    gptController.textEditingController.clear();

    update();
    _chatLog.add('User: $message');

    final response = await gptService.fetchChatGPTResponse(message);

    update();
    _chatLog.add('ChatGPT: $response');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT Ex'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: _chatLog.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_chatLog[index]),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Expanded(
              child: Row(
                children: [
                  TextField(
                    controller: gptController.textEditingController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (gptController.textEditingController.text.isNotEmpty) {
                        sendMessage(gptController.textEditingController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
