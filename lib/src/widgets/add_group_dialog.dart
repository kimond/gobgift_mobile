import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';

class AddGroupDialog extends StatefulWidget {
  @override
  _AddGroupDialogState createState() => new _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final TextEditingController _nameController = new TextEditingController();
  final _authService = new AuthService();
  GobgiftApi api;


  Future<Group> createGroup() async {
    await _authService.init();
    api = new GobgiftApi(_authService);
    Group newGroup = new Group(_nameController.text);
    try {
      newGroup = await api.addGroup(newGroup);
    } on Exception catch (e) {
      print(e);
    }

    return newGroup;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New group'),
        actions: <Widget>[
          new FlatButton(child: new Text('SAVE'), onPressed: () async {
            Group group = await createGroup();
            Navigator.of(context).pop(group);
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
