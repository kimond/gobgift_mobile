import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gobgift_mobile/app_state.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';
import 'package:gobgift_mobile/src/pages/list_detail_page.dart';
import 'package:gobgift_mobile/src/utils.dart';
import 'package:redux/redux.dart';

class WishListTile extends StatelessWidget {
  final Store<AppState> store;
  final WishList wishList;

  WishListTile({this.store, this.wishList});

  Future _handleMenuSelection(BuildContext context, TileAction value) async {
    if (value == TileAction.delete) {
      bool confirmation = await showDialog<bool>(
          context: context,
          child: new AlertDialog(
            content: new Text(
                'You really want to delete the list: ${wishList.name}?'),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('CANCEL')),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('CONFIRM')),
            ],
          ));
      if (confirmation) {
        store.dispatch(new DeleteListAction(wishList));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget secondary;
    secondary = const Text("Groups:");
    return new InkWell(
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) {
            return new ListDetailPage(store: store, wishList: wishList);
          }),
        );
      },
      child: new MergeSemantics(
        child: new ListTile(
          leading: new ExcludeSemantics(
            child: new CircleAvatar(
              child: new Text(wishList.name[0]),
            ),
          ),
          title: new Text('${wishList.name}'),
          subtitle: secondary,
          trailing: new PopupMenuButton<TileAction>(
              onSelected: (TileAction result) =>
                  _handleMenuSelection(context, result),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<TileAction>>[
                    new PopupMenuItem<TileAction>(
                      value: TileAction.delete,
                      child: new ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                      ),
                    ),
                  ]),
        ),
      ),
    );
  }
}
