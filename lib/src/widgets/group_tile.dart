import 'package:flutter/material.dart';
import 'package:gobgift_mobile/src/models/group.dart';


class GroupTile extends StatelessWidget {
  final Group group;

  GroupTile(this.group);

  @override
  Widget build(BuildContext context) {
    Widget secondary;
    secondary = const Text("Owner:");
    return new InkWell(
      onTap: () {},
      child: new MergeSemantics(
        child: new ListTile(
          leading: new ExcludeSemantics(
              child: new CircleAvatar(child: new Text(group.name[0]))),
          title: new Text('${group.name}'),
          subtitle: secondary,
        ),
      ),
    );
  }
}