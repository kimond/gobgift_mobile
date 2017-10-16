import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/group.dart';
import 'package:gobgift_mobile/src/services/auth_service.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
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
  final _authService = new AuthService();
  GobgiftApi api;
  List<Group> _groups = [];

  _GroupPageState({ @required this.store});

  void initState() {
    super.initState();
    store.dispatch(new FetchGroupsAction());
    fetchGroups();
  }

  Future<Null> _handleRefresh() async {
    await fetchGroups();
    store.dispatch(new FetchGroupsAction());
  }

  Future fetchGroups() async {
    await _authService.init();
    api = new GobgiftApi(_authService);
    List<Group> groups = await api.getGroups();
    setState(() {
      _groups = groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        _groups.map((Group group) => new GroupTile(group));
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
        heroTag: 'group-fab',
        onPressed: () async {
          Group newGroup = await Navigator.push(
            context,
            new MaterialPageRoute<Group>(
                builder: (BuildContext context) => new AddGroupDialog(),
                fullscreenDialog: true),
          );
          if (newGroup != null) {
            setState(() {
              _groups.add(newGroup);
            });
          }
        },
        tooltip: 'Add a new group',
        child: new Icon(Icons.add),
      ),
    );
  }
}
