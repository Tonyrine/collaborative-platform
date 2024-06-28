import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _controller = TextEditingController();
  final String apiKey = "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";
  final String apiUrl =
      'https://api.openai.com/v1/engines/davinci-codex/completions';

  List<String> messages = [];

  Future<void> sendMessageToChatGPT(String message) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    var data = {
      'prompt': message,
      'max_tokens': 50,
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        messages.add('You: $message');
        messages.add('ChatGPT: ${jsonResponse['choices'][0]['text']}');
      });
    } else {
      setState(() {
        messages.add('Error: Failed to communicate with ChatGPT');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with ChatGPT')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                    onSubmitted: (value) {
                      sendMessageToChatGPT(value);
                      _controller.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessageToChatGPT(_controller.text);
                    _controller.clear();
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
