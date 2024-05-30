import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final me = 'client@test.com';
  final target = 'sunnyskai.fellow@gmail.com';

  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');
  final DatabaseReference _usersRef =
      FirebaseDatabase.instance.reference().child('users');
  final List<types.Message> _messages = [];
  final _user = types.User(id: 'client@test.com');
  bool _isOpponentTyping = false;

  @override
  void initState() {
    super.initState();
    _messagesRef.onChildAdded.listen(_onMessageAdded);
    _listenToOpponentTyping();
  }

  void _listenToOpponentTyping() {
    _usersRef.child('Staff32').child('email').onValue.listen((event) {
      final email = event.snapshot.value as String;
      setState(() {
        _isOpponentTyping = (email == me);
      });
    });
  }

  void _onMessageAdded(DatabaseEvent event) {
    final messageData = event.snapshot.value as Map<dynamic, dynamic>;
    if ((messageData['to'] == me && messageData['from'] == target) ||
        (messageData['to'] == target && messageData['from'] == me)) {
      final message = types.TextMessage(
        author: types.User(
            id: messageData['from'], firstName: 'AAAA', lastName: "BBBB"),
        createdAt:
            DateTime.parse(messageData['timestamp']).millisecondsSinceEpoch,
        id: event.snapshot.key!,
        text: messageData['content'],
      );

      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final newMessage = {
      'content': message.text,
      'from': me,
      'status': false,
      'timestamp': DateTime.now().toIso8601String(),
      'to': target,
    };

    _messagesRef.push().set(newMessage);
    _setTypingStatus(false);
  }

  void _setTypingStatus(bool isTyping) {
    _usersRef.child('Staff32').update({'email': target});
  }

  void _handleTextChanged(String text) {
    if (text.isNotEmpty) {
      _setTypingStatus(true);
    } else {
      _setTypingStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        typingIndicatorOptions: TypingIndicatorOptions(
            typingUsers: _isOpponentTyping
                ? [types.User(id: target, firstName: 'A', lastName: 'B')]
                : []),
        theme: DefaultChatTheme(
            // INPUT TEXTFIELD THEME
            inputTextCursorColor: Colors.red,
            inputSurfaceTintColor: Colors.yellow,
            inputBackgroundColor: Colors.white,
            inputTextColor: Colors.white,
            inputPadding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
            inputMargin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            inputTextStyle: const TextStyle(
              color: Colors.black,
            ),
            inputBorderRadius: const BorderRadius.horizontal(
              left: Radius.circular(10),
              right: Radius.circular(10),
            ),
            inputTextDecoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: 'Type a message',
              hintStyle: TextStyle(color: Colors.black54),
            ),
            inputContainerDecoration: BoxDecoration(
              color: Colors.blueGrey,
              border: Border.all(color: Colors.blueGrey, width: 1.0),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ),
            ),
            // OTHER CHANGES IN THEME
            primaryColor: const Color.fromARGB(255, 191, 12, 12)),
      ),
    );
  }
}
