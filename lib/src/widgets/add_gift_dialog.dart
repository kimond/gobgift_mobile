import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

class AddGiftDialog extends StatefulWidget {
  final Store<AppState> store;

  AddGiftDialog({this.store});

  @override
  _AddGiftDialogState createState() => new _AddGiftDialogState(store: store);
}

class _AddGiftDialogState extends State<AddGiftDialog> {
  final Store<AppState> store;
  File imageFile;
  final TextEditingController _nameCtrl = new TextEditingController();
  final TextEditingController _priceCtrl = new TextEditingController();
  final TextEditingController _descriptionCtrl = new TextEditingController();
  final TextEditingController _storeCtrl = new TextEditingController();
  final TextEditingController _websiteCtrl = new TextEditingController();
  final _authService = new AuthService();
  GobgiftApi api;

  _AddGiftDialogState({this.store});

  Future<Null> createGift() async {
    await _authService.init();
    final api = new GiftApi(_authService);
    Gift newGift = new Gift(
      null,
      store.state.selectedList.wishList.id,
      _nameCtrl.text,
      price: _priceCtrl.text != "" ? double.parse(_priceCtrl.text): null,
      description: _descriptionCtrl.text,
      store: _storeCtrl.text,
      website: _websiteCtrl.text,
    );
    try {
      newGift = await api.addWithPhoto(newGift, imageFile);
      store.dispatch(new AddGiftAction(newGift));
    } on Exception catch (e) {
      print(e);
    }
  }

  getImage() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      imageFile = _fileName;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(store.state.selectedList.gifts);
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
              decoration: new InputDecoration(labelText: 'Name'),
            ),
          ),
          new Container(
              child: new Column(
            children: <Widget>[
              imageFile != null
                  ? new Image.file(
                      imageFile,
                      height: 300.0,
                    )
                  : null,
              new RaisedButton(
                  child: new ListTile(
                    leading: const Icon(Icons.photo),
                    title: new Text('Upload a photo'),
                  ),
                  onPressed: getImage)
            ]..removeWhere((Widget w) => w == null),
          )),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              keyboardType: TextInputType.number,
              controller: _priceCtrl,
              decoration: new InputDecoration(
                  icon: const Icon(Icons.monetization_on), labelText: 'Price'),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _storeCtrl,
              decoration: new InputDecoration(
                  icon: const Icon(Icons.store), labelText: 'Store'),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _websiteCtrl,
              decoration: new InputDecoration(
                  icon: const Icon(Icons.link), labelText: 'Website'),
            ),
          ),
          new Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new TextField(
              controller: _descriptionCtrl,
              decoration: new InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
          ),
        ],
      )),
      floatingActionButton: null,
    );
  }
}
