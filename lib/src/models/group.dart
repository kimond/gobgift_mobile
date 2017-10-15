library models.group;
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group extends Object with _$GroupSerializerMixin {
  final String name;

  Group(this.name);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
