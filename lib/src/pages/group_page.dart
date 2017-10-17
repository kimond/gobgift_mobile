import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/widgets/add_group_dialog.dart';
import 'package:gobgift_mobile/src/widgets/group_tile.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

class GroupPage extends StatefulWidget {
  final Store<AppState> store;

  GroupPage({Key key, @required this.store}) : super(key: key);

  @override
  _GroupPageState createState() => new _GroupPageState(store: store);
}

class _GroupPageState extends State<GroupPage> {
  final Store<AppState> store;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _GroupPageState({@required this.store});

  void initState() {
    super.initState();
    store.dispatch(new FetchGroupsAction());
  }

  Future<Null> _handleRefresh() async {
    store.dispatch(new FetchGroupsAction());
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
          child: new StoreConnector<AppState, List<Group>>(
            converter: (store) => store.state.groups,
            builder: (context, groups) => new ListView(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  children: groups
                      .map((Group group) =>
                          new GroupTile(store: store, group: group))
                      .toList(),
                ),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        heroTag: 'group-fab',
        onPressed: () async {
          Navigator.of(context).push(
                new MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        new AddGroupDialog(store: store),
                    fullscreenDialog: true),
              );
        },
        tooltip: 'Add a new group',
        child: new Icon(Icons.add),
      ),
    );
  }
}
