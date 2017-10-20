library models.wish_list;

import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish_list.g.dart';

@JsonSerializable()
class WishList extends Object with RestResource, _$WishListSerializerMixin {
  final String name;
  final int _id;

  WishList(this._id, this.name);

  factory WishList.fromJson(Map<String, dynamic> json) =>
      _$WishListFromJson(json);

  @override
  int get id => _id;
}
