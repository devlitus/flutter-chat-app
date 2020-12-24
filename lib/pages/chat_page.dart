import 'dart:io';
import 'package:chat_app/models/message_response.dart';
import 'package:chat_app/services/atuh_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/widgets/chat_messages.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWrite = false;
  List<ChatMessage> _message = [];
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('message-personal', _lisenerMessage);
    _loadinHistory(chatService.userPara.uid);
  }

  void _loadinHistory(String userId) async {
    List<Message> chat = await chatService.getChat(userId);
    final history = chat.map((m) => ChatMessage(text: m.message, uid: m.de));
    setState(() {
      _message.insertAll(0, history);
    });
  }

  void _lisenerMessage(dynamic payload) {
    ChatMessage message =
        ChatMessage(text: payload['message'], uid: payload['de']);
    setState(() {
      _message.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPara = chatService.userPara;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(userPara.name.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
            ),
            Text(userPara.name, style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _message.length,
                itemBuilder: (_, i) => _message[i],
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              height: 60,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String value) {
                  setState(() {
                    (value.trim().length > 0)
                        ? _isWrite = true
                        : _isWrite = false;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: (Platform.isAndroid)
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          color: Colors.blueAccent,
                          icon: Icon(Icons.send),
                          onPressed: _isWrite
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    )
                  : CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _isWrite
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(uid: authService.user.uid, text: text);
    _message.insert(0, newMessage);
    setState(() {
      _isWrite = false;
    });

    socketService.emit('message-personal', {
      'de': authService.user.uid,
      'para': chatService.userPara.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    socketService.socket.off('message-personal');
    super.dispose();
  }
}
