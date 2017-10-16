import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/wish_list.dart';


class WishListTile extends StatelessWidget {
  final WishList wishList;

  WishListTile(this.wishList);

  @override
  Widget build(BuildContext context) {
    Widget secondary;
    secondary = const Text("Groups:");
    return new InkWell(
      onTap: () {},
      child: new MergeSemantics(
        child: new ListTile(
          leading: new ExcludeSemantics(
              child: new CircleAvatar(child: new Text(wishList.name[0]))),
          title: new Text('${wishList.name}'),
          subtitle: secondary,
        ),
      ),
    );
  }
}