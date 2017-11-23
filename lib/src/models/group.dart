library models.group;

import 'package:gobgift_mobile/src/models/user.dart';
import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Object with RestResource, _$GroupSerializerMixin {
  final String name;
  @JsonKey(name: 'id', includeIfNull: false)
  final int _id;
  final User owner;

  Group(this._id, this.name, {this.owner});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  int get id => _id;
}
