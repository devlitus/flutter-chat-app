import 'package:flutter/material.dart';

import 'package:chat_app/routes/main_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: appRutes,
    );
  }
}
