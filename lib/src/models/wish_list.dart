library models.wish_list;
import 'package:json_annotation/json_annotation.dart';

part 'wish_list.g.dart';

@JsonSerializable()
class WishList extends Object with _$WishListSerializerMixin {
  final String name;

  WishList(this.name);

  factory WishList.fromJson(Map<String, dynamic> json) => _$WishListFromJson(json);
}
