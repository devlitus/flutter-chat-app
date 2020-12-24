import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/services/atuh_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/models/user.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final userService = UserService();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<User> users = [];
  @override
  void initState() {
    _loadingUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
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
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          (socketService.serverStatus == ServerStatus.Online)
              ? IconButton(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                  ),
                  onPressed: () {})
              : IconButton(
                  icon: Icon(
                    Icons.offline_bolt_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {})
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userPara = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadingUsers() async {
    users = await userService.getUsers();
    setState(() {
      _refreshController.refreshCompleted();
    });
    // await Future.delayed(Duration(microseconds: 1000));
  }
}
