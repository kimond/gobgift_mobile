import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class AddGroupDialog extends StatefulWidget {
  final Store<AppState> store;

  AddGroupDialog({this.store});

  @override
  _AddGroupDialogState createState() => new _AddGroupDialogState(store: store);
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final Store<AppState> store;
  final TextEditingController _nameController = new TextEditingController();
  final _authService = new AuthService();
  GobgiftApi api;

  _AddGroupDialogState({this.store});

  Future<Null> createGroup() async {
    await _authService.init();
    api = new GroupsApi(_authService);
    Group newGroup = new Group(null, _nameController.text);
    try {
      newGroup = await api.add(newGroup);
      store.dispatch(new AddGroupAction(newGroup));
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Group'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('SAVE'),
              onPressed: () async {
                await createGroup();
                Navigator.of(context).pop();
              }),
        ],
      ),
      body: new Form(
          child: new ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _nameController,
              decoration: new InputDecoration(hintText: 'Group name'),
            ),
          )
        ],
      )),
      floatingActionButton: null,
    );
  }
}
