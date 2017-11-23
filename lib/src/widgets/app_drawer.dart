import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/services.dart';
import 'package:gobgift_mobile/src/models/user.dart';
import 'package:gobgift_mobile/src/pages/login_page.dart';
import 'package:redux/redux.dart';

class AppDrawer extends StatefulWidget {
  final Store<AppState> store;

  AppDrawer({this.store});

  _AppDrawerState createState() => new _AppDrawerState(store: store);
}

class _AppDrawerState extends State<AppDrawer> with TickerProviderStateMixin {
  final Store<AppState> store;
  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;

  _AppDrawerState({this.store});

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<Null> _logout() async {
    final authService = new AuthService();
    await authService.logout();
    store.dispatch(new LogoutAction());
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new StoreConnector<AppState, User>(
              converter: (store) => store.state.user,
              builder: (BuildContext context, user) {
                return new UserAccountsDrawerHeader(
                  accountName: new Text(user.username),
                  accountEmail: const Text(''),
                );
              }),
          new ClipRect(
            child: new Stack(
              children: <Widget>[
                new FadeTransition(
                  opacity: _drawerContentsOpacity,
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: const Text('Logout'),
                          onTap: () {
                            _logout();
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute<Null>(
                                builder: (BuildContext context) =>
                                    new LoginPage(store: store),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
