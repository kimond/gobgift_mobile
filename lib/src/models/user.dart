library models.comment;

import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Object with RestResource, _$UserSerializerMixin {
  final int id;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  User(this.id, this.username, this.firstName, this.lastName);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}
