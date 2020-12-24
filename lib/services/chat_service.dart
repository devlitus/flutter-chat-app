import 'package:chat_app/models/message_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/atuh_service.dart';

class ChatService with ChangeNotifier {
  User userPara;

  Future<List<Message>> getChat(String userId) async {
    final resp =
        await http.get('${Environment.apiUrl}/message/$userId', headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken(),
    });

    final messageResponse = messageResponseFromJson(resp.body);
    return messageResponse.message;
  }
}
