import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/atuh_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _shocket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _shocket;
  Function get emit => _shocket.emit;

  // Dart client
  void connect() async {
    final token = await AuthService.getToken();
    _shocket = IO.io(
        Environment.socketUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token})
            .build());

    _shocket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _shocket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      print('desconectado');
      notifyListeners();
    });
  }

  void disconnect() {
    _shocket.io.disconnect();
  }
}
