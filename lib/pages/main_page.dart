import 'package:chatgpt/component/chat_message.dart';
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
  final List<ChatMessage> _chatLog = [];

  void update() => setState(() {});

  void sendMessage(String prompt) async {
    gptController.textEditingController.clear();

    update();
    // insert(채팅 내용을 추가할 때 마다 0번에 배치 채팅 입력시 reverse - true 와 함께 사용하면 카톡처럼 채팅 메시지 구현)
    _chatLog.insert(0, ChatMessage(role: 'User', content: prompt));

    final response = await gptService.fetchChatGPTResponse(prompt);

    update();
    _chatLog.insert(0, ChatMessage(role: 'ChatGPT', content: response));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT Ex'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // 역순 배치
              reverse: true,
              itemCount: _chatLog.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: _chatLog[index].role == 'User'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: _chatLog[index].role == 'User'
                          ? Colors.black
                          : Colors.grey,
                      child: Text(
                        ('${_chatLog[index].role}: ${_chatLog[index].content}'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: gptController.textEditingController,
                    decoration:
                        const InputDecoration(hintText: 'Type a message'),
                  ),
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
        ],
      ),
    );
  }
}
