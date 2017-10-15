import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = new GoogleSignIn();
AuthService authService = new AuthService();

class GroupPage extends StatefulWidget {
  GroupPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<GroupPage> {
  final _authService = new AuthService();
  GobgiftApi api;
  List<Group> _groups = [];

  Future fetchGroups() async {
    await _authService.init();
    api = new GobgiftApi(_authService);
    List<Group> groups = await api.getGroups();
    setState(() {
      _groups = groups;
    });
  }

  Widget buildListTile(BuildContext context, Group group) {
    Widget secondary;
    secondary = const Text("Owner:");
    return new MergeSemantics(
      child: new ListTile(
        leading: new ExcludeSemantics(child: new CircleAvatar(child: new Text(group.name))),
        title: new Text('${group.name}'),
        subtitle: secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchGroups();
    Iterable<Widget> listTiles =
        _groups.map((Group group) => buildListTile(context, group));
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gobgift'),
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: listTiles.toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
