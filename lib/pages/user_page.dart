import 'package:flutter/material.dart';

import 'package:chat_app/services/atuh_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/user.dart';

class UserPage extends StatelessWidget {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final users = [
    User(uid: '1', name: 'Carles', email: 'test1@test.com', online: true),
    User(uid: '2', name: 'Melissa', email: 'test2@test.com', online: false),
    User(uid: '3', name: 'Antonio', email: 'test3@test.com', online: true),
    User(uid: '4', name: 'Juan', email: 'test4@test.com', online: false),
    User(uid: '5', name: 'Maria', email: 'test5@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final users = authService.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          users.name,
          style: TextStyle(color: Colors.black45),
        ),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
            // TODO: Desconectarse el socket serve
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.check_circle_outline,
                color: Colors.blue,
              ),
              onPressed: () {}),
          /* IconButton(
                icon: Icon(
                  Icons.offline_bolt_outlined,
                  color: Colors.red,
                ),
                onPressed: () {}) */
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _loadingUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[200],
        ),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(users[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: users.length,
    );
  }

  ListTile _usuarioListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  _loadingUsers() async {
    await Future.delayed(Duration(microseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
