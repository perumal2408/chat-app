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

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(jsonEncode({"message": _controller.text,"name":"vijay","timestamp":  DateTime.now().millisecondsSinceEpoch }));
      setState(() {
        // _messages.add(_controller.text);
        _controller.clear();
      });
    }
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
            child: StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(jsonDecode(snapshot.data!.toString()));
                  final response = jsonDecode(snapshot.data!.toString()) as Map;
                  if (response.containsKey("message")) {
                    _messages.add(response);
                  }                 
                }
                return ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Align(
                        alignment: index % 2 == 0
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: index % 2 == 0 ? Colors.blue[100] : Colors.green[100],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(_messages[index]["message"]),
                        ),
                      ),
                    );
                  },
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
