import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/widgets/add_gift_dialog.dart';
import 'package:redux/redux.dart';

class ListDetailPage extends StatefulWidget {
  final Store<AppState> store;
  final WishList wishList;

  ListDetailPage({Key key, this.store, this.wishList}) : super(key: key);

  @override
  _ListDetailPageState createState() => new _ListDetailPageState(store: store);
}

class _ListDetailPageState extends State<ListDetailPage> {
  final Store<AppState> store;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _ListDetailPageState({this.store});

  void initState() {
    super.initState();
  }

  Future<Null> _handleRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gobgift'),
      ),
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: new Scrollbar(
          child: new Text('test'),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        new AddGiftDialog(store: store),
                    fullscreenDialog: true),
              );
        },
        tooltip: 'Add new gift',
        child: new Icon(Icons.add),
      ),
    );
  }
}
