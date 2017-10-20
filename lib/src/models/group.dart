library models.group;

import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends RestResource with _$GroupSerializerMixin {
  @JsonKey(includeIfNull: false)
  final int id;
  final String name;

  Group(this.id, this.name);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
