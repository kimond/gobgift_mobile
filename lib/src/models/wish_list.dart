library models.wish_list;

import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish_list.g.dart';

@JsonSerializable()
class WishList extends RestResource with _$WishListSerializerMixin {
  @JsonKey(includeIfNull: false)
  final int id;
  final String name;

  WishList(this.id, this.name);

  factory WishList.fromJson(Map<String, dynamic> json) =>
      _$WishListFromJson(json);
}
