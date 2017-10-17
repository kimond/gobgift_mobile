import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/widgets/add_list_dialog.dart';
import 'package:gobgift_mobile/src/widgets/wish_list_tile.dart';
import 'package:redux/redux.dart';

class ListPage extends StatefulWidget {
  final Store<AppState> store;

  ListPage({Key key, this.store}) : super(key: key);

  @override
  _ListPageState createState() => new _ListPageState(store: store);
}

class _ListPageState extends State<ListPage> {
  final Store<AppState> store;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _ListPageState({this.store});

  void initState() {
    super.initState();
    store.dispatch(new FetchListsAction());
  }

  Future<Null> _handleRefresh() async {
    store.dispatch(new FetchListsAction());
  }

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
          child: new StoreConnector<AppState, List<WishList>>(
            converter: (store) => store.state.wishLists,
            builder: (context, wishLists) => new ListView(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  children: wishLists
                      .map((WishList wishList) =>
                          new WishListTile(store: store, wishList: wishList))
                      .toList(),
                ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        new AddListDialog(store: store),
                    fullscreenDialog: true),
              );
        },
        tooltip: 'Add new list',
        child: new Icon(Icons.add),
      ),
    );
  }
}
