import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/widgets/add_gift_dialog.dart';
import 'package:gobgift_mobile/src/widgets/gift_grid.dart';
import 'package:redux/redux.dart';

class ListDetailPage extends StatefulWidget {
  final Store<AppState> store;
  final WishList wishList;

  ListDetailPage({Key key, this.store, this.wishList}) : super(key: key);

  @override
  _ListDetailPageState createState() =>
      new _ListDetailPageState(store: store, wishList: wishList);
}

class _ListDetailPageState extends State<ListDetailPage> {
  final Store<AppState> store;
  final WishList wishList;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _ListDetailPageState({this.store, this.wishList});

  Future<Null> fetchGifts() async {
    store.dispatch(new FetchGiftsForSelectedListAction());
  }

  void initState() {
    super.initState();
    store.dispatch(new SetSelectedListAction(wishList));
    fetchGifts();
  }

  Future<Null> _handleRefresh() async {
    fetchGifts();
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
          child: new StoreConnector<AppState, bool>(
              builder: (context, isLoading) {
                if (isLoading) {
                  return new Center(child: new CircularProgressIndicator());
                } else {
                  return new StoreConnector<AppState, List<Gift>>(
                      builder: (context, gifts) => gifts.isNotEmpty
                          ? new GiftGrid(gifts: gifts)
                          : new Text('No gift'),
                      converter: (store) => store.state.selectedList.gifts);
                }
              },
              converter: (store) => store.state.selectedList.isLoading)),
      floatingActionButton: new FloatingActionButton(
        heroTag: 'addGift',
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
