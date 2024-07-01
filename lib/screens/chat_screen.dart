import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel channel = IOWebSocketChannel.connect('wss://edge-chat-demo.cloudflareworkers.com/api/room/11ws23/websocket');
  final List<Map> _messages = [];
  final String currentUser = "vijay"; // Current user's name

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = {
        "message": _controller.text,
        "name": currentUser,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      };
      channel.sink.add(jsonEncode(message));
      setState(() {
        _messages.add(message);
        _controller.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      final response = jsonDecode(data) as Map;
      if (response.containsKey("message") && response["name"] != currentUser) {
        setState(() {
          _messages.add(response);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with User'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser = message["name"] == currentUser;
                return ListTile(
                  title: Align(
                    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isCurrentUser ? Colors.green[100] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(message["message"]),
                    ),
                  ),
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
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
