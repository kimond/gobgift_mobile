library models.gift;

import 'package:gobgift_mobile/src/services/gobgift_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gift.g.dart';

@JsonSerializable()
class Gift extends Object with RestResource, _$GiftSerializerMixin {
  @JsonKey(name: 'wishlist')
  final int wishList;
  final String name;
  @JsonKey(includeIfNull: false)
  final String photo;
  @JsonKey(includeIfNull: false)
  final String description;
  @JsonKey(includeIfNull: false)
  final double price;
  @JsonKey(includeIfNull: false)
  final String website;
  @JsonKey(includeIfNull: false)
  final String store;
  @JsonKey(includeIfNull: false)
  final bool purchased;
  @JsonKey(name: 'id', includeIfNull: false)
  final int _id;

  Gift(
    this._id,
    this.wishList,
    this.name, {
    this.photo,
    this.description,
    this.price,
    this.website,
    this.store,
    this.purchased,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  @override
  int get id => _id;
}
