import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/gift.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/widgets/GiftGrid.dart';
import 'package:gobgift_mobile/src/widgets/add_gift_dialog.dart';
import 'package:redux/redux.dart';

class GiftPage extends StatefulWidget {
  final Store<AppState> store;
  final Gift gift;

  GiftPage({Key key, this.store, this.gift}) : super(key: key);

  @override
  _GiftPageState createState() => new _GiftPageState(store: store, gift: gift);
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _GiftPageState extends State<GiftPage> {
  final Store<AppState> store;
  final Gift gift;
  final double _appBarHeight = 256.0;

  _GiftPageState({this.store, this.gift});

  Future<Null> fetchGifts() async {
    store.dispatch(new FetchGiftsForSelectedListAction());
  }

  void initState() {
    super.initState();
  }

  Widget giftPhoto() {
    return gift.photo != null
        ? new Image.network(
            gift.photo,
            fit: BoxFit.cover,
            height: _appBarHeight,
          )
        : new Image.asset(
            'lib/assets/giftplaceholder.png',
            fit: BoxFit.cover,
            height: _appBarHeight,
          );
  }

  Future<Null> _handleRefresh() async {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            expandedHeight: _appBarHeight,
            backgroundColor: Colors.transparent,
            pinned: true,
            floating: false,
            snap: false,
            actions: <Widget>[
              new IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () {},
              )
            ],
            flexibleSpace: new FlexibleSpaceBar(
              title: new Text(gift.name),
              background: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  giftPhoto(),
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                          begin: const Alignment(0.0, -1.0),
                          end: const Alignment(0.0, -0.4),
                          colors: const <Color>[
                            Colors.black54,
                            Colors.transparent
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(<Widget>[
              gift.price != null
                  ? new ListTile(
                      leading: const Icon(Icons.monetization_on),
                      title: new Text(gift.price.toString()),
                    )
                  : null,
              gift.store != null
                  ? new ListTile(
                      leading: const Icon(Icons.store),
                      title: new Text(gift.store),
                    )
                  : null,
              gift.website != null
                  ? new ListTile(
                      leading: const Icon(Icons.link),
                      title: new Text(gift.website),
                    )
                  : null,
              new Divider(height: 32.0),
              new Container(
                margin: new EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(right: 32.0),
                      child: new Icon(
                        Icons.description,
                        color: Colors.grey,
                      ),
                    ),
                    new Text("Description",
                        style: Theme.of(context).textTheme.title),
                  ],
                ),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 72.0, right: 16.0),
                child: new Text(
                  gift.description,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ]..removeWhere((Widget w) => w == null)),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        heroTag: 'comment',
        onPressed: () async {
          await Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        new AddGiftDialog(store: store),
                    fullscreenDialog: true),
              );
        },
        tooltip: 'Add new gift',
        child: new Icon(Icons.comment),
      ),
    );
  }
}
