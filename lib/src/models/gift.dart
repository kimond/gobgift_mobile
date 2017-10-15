library models.gift;

import 'package:json_annotation/json_annotation.dart';

part 'gift.g.dart';

@JsonSerializable()
class Gift extends Object with _$GiftSerializerMixin {
  @JsonKey(includeIfNull: false)
  final int id;
  final String name;
  final String photo;
  final String description;
  final double price;
  final String website;
  final String store;
  final bool purchased;

  Gift(this.id, this.name, this.photo, this.description, this.price,
      this.website, this.store, this.purchased);

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);
}
