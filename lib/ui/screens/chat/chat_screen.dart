// chat_screen.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/message_model.dart';
import '../../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserEmail;
  final String otherUserEmail;

  ChatScreen(
      {this.currentUserEmail = 'client@gmail.com',
      this.otherUserEmail = 'john.tester@gmail.com'});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageService _messageService = MessageService();
  final TextEditingController _controller = TextEditingController();
  final Uuid _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.otherUserEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageService.getMessages(
                  widget.currentUserEmail, widget.otherUserEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(message.sender),
                        trailing: Text(message.timestamp.toString()),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      final message = Message(
                        id: _uuid.v4(),
                        sender: widget.currentUserEmail,
                        receiver: widget.otherUserEmail,
                        content: _controller.text,
                        timestamp: DateTime.now(),
                      );
                      await _messageService.sendMessage(message);
                      _controller.clear();
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
