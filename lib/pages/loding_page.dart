import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/user_page.dart';
import 'package:chat_app/services/atuh_service.dart';
import 'package:chat_app/services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoadingState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere....'),
          );
        },
      ),
    );
  }

  Future checkLoadingState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authenticated = await authService.isLoginIN();
    if (authenticated) {
      socketService.connect();
      // Navigator.pushReplacementNamed(context, 'user');
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UserPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionDuration: Duration(milliseconds: 0),
          ));
    }
  }
}
