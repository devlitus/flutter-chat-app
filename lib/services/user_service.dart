import 'package:chat_app/models/user_rsponse.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/atuh_service.dart';

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/users', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });
      final usersResponse = userResponseFromJson(resp.body);
      return usersResponse.users;
    } catch (error) {
      return [];
    }
  }
}
