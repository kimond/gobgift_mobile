import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:redux/redux.dart';

class AddListDialog extends StatefulWidget {
  final Store<AppState> store;

  AddListDialog({this.store});

  @override
  _AddListDialogState createState() => new _AddListDialogState(store: store);
}

class _AddListDialogState extends State<AddListDialog> {
  final Store<AppState> store;
  final TextEditingController _nameController = new TextEditingController();
  final _authService = new AuthService();
  GobgiftApi api;

  _AddListDialogState({this.store});

  Future<Null> createWishList() async {
    await _authService.init();
    api = new ListsApi(_authService);
    WishList newWishList = new WishList(null, _nameController.text);
    try {
      newWishList = await api.add(newWishList);
      store.dispatch(new AddListAction(newWishList));
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('New List'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('SAVE'),
              onPressed: () async {
                WishList wishList = await createWishList();
                Navigator.of(context).pop(wishList);
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
              decoration: new InputDecoration(hintText: 'List name'),
            ),
          )
        ],
      )),
      floatingActionButton: null,
    );
  }
}
