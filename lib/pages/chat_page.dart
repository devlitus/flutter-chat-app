import 'dart:io';

import 'package:chat_app/widgets/chat_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWrite = false;
  List<ChatMessage> _message = [
    ChatMessage(uid: '123', text: 'Hola Mundo'),
    ChatMessage(uid: '124', text: 'Hola Mundo'),
    ChatMessage(uid: '123', text: 'Hola Mundo'),
    ChatMessage(uid: '124', text: 'Hola Mundo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
            ),
            Text('Test', style: TextStyle(color: Colors.black87)),
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

  _handleSubmit(String value) {
    if (value.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(uid: '123', text: value);
    _message.insert(0, newMessage);
    setState(() {
      _isWrite = false;
    });
  }

  @override
  void dispose() {
    // TODO: off de sockets
    super.dispose();
  }
}
