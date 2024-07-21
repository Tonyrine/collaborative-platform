import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'more.dart';
import 'package:clpfus/screens/user_id_provider.dart'; // Import the UserIdProvider

class ChatPage extends StatefulWidget {
  final String id;
  final String question;
  final String description;
  final String image;
  final String subject;
  final String source;

  const ChatPage({
    Key? key,
    required this.id,
    required this.question,
    required this.description,
    required this.image,
    required this.subject,
    required this.source,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _textController = TextEditingController();
  String? _imagePath;
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    // Set up a timer to fetch messages periodically (e.g., every 5 seconds)
    _timer = Timer.periodic(
        const Duration(seconds: 5), (Timer t) => _fetchMessages());
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    print("Fetching messages for ID: ${widget.id}");
    String url;
    if (widget.source == 'diss') {
      url = 'http://192.168.43.245/CLP/diss/get_diss_reply.php';
    } else {
      url = 'http://192.168.43.245/CLP/questions/get_answers.php';
    }

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'id': widget.id}),
      headers: {"Content-Type": "application/json"},
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
        });
        // Scroll to the bottom after fetching messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          messages = [
            {'content': 'Failed to load messages'}
          ];
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final content = _textController.text.trim();
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
    final userId = userIdProvider.userId;

    if (content.isNotEmpty) {
      final url = widget.source == 'diss'
          ? 'http://192.168.43.245/CLP/diss/send_diss_reply.php'
          : 'http://192.168.43.245/CLP/questions/send_qns_reply.php';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['userId'] = userId;
      request.fields['questionId'] = widget.id;
      request.fields['content'] = content;

      if (_imagePath != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _imagePath!));
      }

      var response = await request.send();

      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        _textController.clear();
        setState(() {
          _imagePath = null;
        });
        _fetchMessages(); // Fetch updated messages after sending
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _showFullScreenImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userIdProvider = Provider.of<UserIdProvider>(context, listen: false);
    final userId = userIdProvider.userId;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MorePage(
                  id: widget.id,
                  question: widget.question,
                  description: widget.description,
                  image: widget.image,
                  subject: widget.subject,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.subject,
                style:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFCB997E),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3, // Adjust the opacity value as needed
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/ttot.jpg"), // Background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final imageUrl = message['image'] != null &&
                            message['image'].isNotEmpty
                        ? 'http://192.168.43.245/clp/images/${message['image']}'
                        : null;
                    final isOwnMessage = message['userId'].toString() == userId;

                    print("Message userId: ${message['userId']}");
                    print("Logged in userId: $userId");

                    return FractionallySizedBox(
                      widthFactor:
                          0.50, // Adjust this value to set the width of the message tiles
                      alignment: isOwnMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isOwnMessage
                              ? const Color(0xFFFFE8D6)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOwnMessage
                                  ? 'ME'
                                  : message['userId'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isOwnMessage ? Colors.blue : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            if (imageUrl != null)
                              GestureDetector(
                                onTap: () {
                                  _showFullScreenImage(imageUrl);
                                },
                                child: Container(
                                  width: 100, // Adjust the width as needed
                                  height: 100, // Adjust the height as needed
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(),
                                  ),
                                ),
                              ),
                            if (imageUrl != null) const SizedBox(height: 8.0),
                            Text(message['content'] ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0), // Add vertical padding for larger text area
        color: Colors.white,
        child: Column(
          children: [
            if (_imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.file(
                  File(_imagePath!),
                  width: 100,
                  height: 100,
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical:
                            12.0), // Add padding inside the text field container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: _textController,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Send a message...',
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      maxLines: null, // Allow multiple lines
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imagePath;

  const FullScreenImagePage({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(imagePath),
        ),
      ),
    );
  }
}
