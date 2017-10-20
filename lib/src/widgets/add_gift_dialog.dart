import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class AddGiftDialog extends StatefulWidget {
  final Store<AppState> store;

  AddGiftDialog({this.store});

  @override
  _AddGiftDialogState createState() => new _AddGiftDialogState(store: store);
}

class _AddGiftDialogState extends State<AddGiftDialog> {
  final Store<AppState> store;
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _descriptionCtrl = new TextEditingController();
  final TextEditingController _storeCtrl = new TextEditingController();
  final _authService = new AuthService();
  GobgiftApi api;

  _AddGiftDialogState({this.store});

  Future<Null> createGift() async {
    await _authService.init();
    api = new GobgiftApi(_authService);
    Gift newGift = new Gift(
      null,
      store.state.selectedList.wishList.id,
      _nameCtrl.text,
      description: _descriptionCtrl.text,
      store: _storeCtrl.text,
    );
    try {
      newGift = new Gift.fromJson(await api.add<Gift>(newGift));
      store.dispatch(new AddGiftAction(newGift));
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New Gift'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('SAVE'),
              onPressed: () async {
                await createGift();
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
              controller: _nameCtrl,
              decoration: new InputDecoration(hintText: 'Gift name'),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _descriptionCtrl,
              decoration: new InputDecoration(hintText: 'Description'),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _storeCtrl,
              decoration: new InputDecoration(hintText: 'Store'),
            ),
          )
        ],
      )),
      floatingActionButton: null,
    );
  }
}
