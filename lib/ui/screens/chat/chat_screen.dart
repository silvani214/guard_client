import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:firebase_database/firebase_database.dart';
import 'package:guard_client/services/auth_service.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../../models/user_model.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatefulWidget {
  final UserModel guard;

  ChatScreen({
    required this.guard,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final getIt = GetIt.instance;
  late UserModel me;
  late UserModel target;

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

    initializeAsync();
  }

  Future<void> initializeAsync() async {
    target = widget.guard;
    me = (await getIt<AuthService>().getUserDetail())!;
    print(target.email);
    print(me.email);
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
    late var author;
    if (messageData['to'] == me.email && messageData['from'] == target.email) {
      // incoming
      author = types.User(
          id: target.email,
          firstName: target.firstName,
          lastName: target.lastName);
    } else if (messageData['to'] == target.email &&
        messageData['from'] == me.email) {
      author = types.User(
          id: me.email, firstName: me.firstName, lastName: me.lastName);
    } else {
      return;
    }
    final message = types.TextMessage(
      author: author,
      createdAt:
          DateTime.parse(messageData['timestamp']).millisecondsSinceEpoch,
      id: event.snapshot.key!,
      text: messageData['content'],
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final newMessage = {
      'content': message.text,
      'from': me.email,
      'status': false,
      'timestamp': DateTime.now().toIso8601String(),
      'to': target.email,
    };

    _messagesRef.push().set(newMessage);
    _setTypingStatus(false);
  }

  void _setTypingStatus(bool isTyping) {
    _usersRef.child('Staff32').update({'email': target.email});
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
                ? [
                    types.User(
                        id: target.email,
                        firstName: target.firstName,
                        lastName: target.lastName)
                  ]
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
