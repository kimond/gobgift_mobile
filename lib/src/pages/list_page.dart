import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:gobgift_mobile/src/widgets/add_list_dialog.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => new _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final _authService = new AuthService();
  GobgiftApi api;
  List<WishList> _wishLists = [];

  void initState() {
    super.initState();
    fetchWishLists();
  }

  Future<Null> _handleRefresh() async {
    await fetchWishLists();
  }

  Future fetchWishLists() async {
    await _authService.init();
    api = new GobgiftApi(_authService);
    List<WishList> wishLists = await api.getWishLists();
    setState(() {
      _wishLists = wishLists;
    });
  }

  Widget buildListTile(BuildContext context, WishList wishList) {
    Widget secondary;
    secondary = const Text("Groups:");
    return new MergeSemantics(
      child: new ListTile(
        leading: new ExcludeSemantics(
            child: new CircleAvatar(child: new Text(wishList.name[0]))),
        title: new Text('${wishList.name}'),
        subtitle: secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        _wishLists.map((WishList group) => buildListTile(context, group));
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Gobgift'),
      ),
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        child: new Scrollbar(
          child: new ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: listTiles.toList(),
          ),
        ),
        onRefresh: _handleRefresh,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          WishList newWishList = await Navigator.push(
            context,
            new MaterialPageRoute<WishList>(
                builder: (BuildContext context) => new AddListDialog(),
                fullscreenDialog: true),
          );
          if (newWishList != null) {
            setState((){
              _wishLists.add(newWishList);
            });
          }
        },
        tooltip: 'Add new list',
        child: new Icon(Icons.add),
      ),
    );
  }
}
